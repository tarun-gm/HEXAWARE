-- =====================================================
-- file : cursor.sql  (run after views.sql)
-- task 4 : cursor with a not found handler, then the set-based rewrite
-- task 5 : both procedures also pass a running count back through an inout parameter
-- lapsed premium = active policy whose premium_paid_until date is already over
-- =====================================================
use insurance_db;

drop procedure if exists sp_lapse_policies_cursor;
drop procedure if exists sp_lapse_policies_setbased;

delimiter $$

-- ---------- version 1 : cursor (row by row) ----------
create procedure sp_lapse_policies_cursor(inout p_processed_count int)
begin
declare v_policy_id int;
declare v_old_status varchar(10);
declare v_done int default 0;
declare cur_lapsed cursor for
select policy_id, status
from policies
where status = 'ACTIVE' and premium_paid_until < curdate();
declare continue handler for not found set v_done = 1;

if p_processed_count is null then
set p_processed_count = 0;
end if;

open cur_lapsed;
read_loop: loop
fetch cur_lapsed into v_policy_id, v_old_status;
if v_done = 1 then
leave read_loop;
end if;
update policies set status = 'LAPSED' where policy_id = v_policy_id;
insert into lapse_log (policy_id, old_status, new_status, logged_by)
values (v_policy_id, v_old_status, 'LAPSED', 'cursor');
set p_processed_count = p_processed_count + 1;
end loop;
close cur_lapsed;
end$$

-- ---------- version 2 : set-based rewrite (two statements, no loop) ----------
create procedure sp_lapse_policies_setbased(inout p_processed_count int)
begin
declare v_rows int default 0;
declare exit handler for sqlexception
begin
rollback;
resignal;
end;

if p_processed_count is null then
set p_processed_count = 0;
end if;

start transaction;
-- log first, while the status is still ACTIVE, so old_status is correct
insert into lapse_log (policy_id, old_status, new_status, logged_by)
select policy_id, status, 'LAPSED', 'set-based'
from policies
where status = 'ACTIVE' and premium_paid_until < curdate();
update policies
set status = 'LAPSED'
where status = 'ACTIVE' and premium_paid_until < curdate();
set v_rows = row_count();
commit;
set p_processed_count = p_processed_count + v_rows;
end$$

delimiter ;

-- ---------- test 1 : cursor version ----------
select policy_id, status, premium_paid_until from policies order by policy_id;
set @lapsed = 0;
call sp_lapse_policies_cursor(@lapsed);
select @lapsed as lapsed_by_cursor;
select * from lapse_log;

-- ---------- reset (test only) : put the policies back so the set-based version can be tested ----------
update policies set status = 'ACTIVE' where policy_id in (select policy_id from lapse_log where logged_by = 'cursor');
delete from lapse_log;

-- ---------- test 2 : set-based version ----------
set @lapsed = 0;
call sp_lapse_policies_setbased(@lapsed);
select @lapsed as lapsed_by_setbased;
select * from lapse_log;
select policy_id, status, premium_paid_until from policies order by policy_id;
