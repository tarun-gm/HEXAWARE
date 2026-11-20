-- =====================================================
-- file : procedures.sql  (run after views.sql)
-- task 3 : function + report, task 2 : sp_renew_policy, task 5 : inout parameter
-- =====================================================
use insurance_db;

drop function if exists fn_premium_with_no_claim_discount;
drop procedure if exists sp_renew_policy;

delimiter $$

-- ---------- task 3 : no claim discount function ----------
-- 0 years = 0%, 1 year = 5%, 2 years = 10%, 3 years = 15%, 4 or more years = 20%
create function fn_premium_with_no_claim_discount(p_base_premium decimal(10,2), p_no_claim_years int)
returns decimal(10,2)
deterministic
begin
declare v_discount decimal(4,2);
set v_discount = case
when p_no_claim_years >= 4 then 0.20
when p_no_claim_years = 3 then 0.15
when p_no_claim_years = 2 then 0.10
when p_no_claim_years = 1 then 0.05
else 0
end;
return round(p_base_premium * (1 - v_discount), 2);
end$$

-- ---------- task 2 and task 5 : renew one policy ----------
-- p_processed_count is an inout parameter: the caller passes the running count in,
-- the procedure adds 1 for every policy it renews and passes the new count back
create procedure sp_renew_policy(
in p_policy_id int,
inout p_processed_count int,
out p_message varchar(100)
)
main: begin
declare v_status varchar(10) default null;
declare v_base_premium decimal(10,2);
declare v_old_premium decimal(10,2);
declare v_no_claim_years int default 0;
declare v_new_no_claim_years int default 0;
declare v_pending_claims int default 0;
declare v_recent_claims int default 0;
declare v_new_premium decimal(10,2);

-- exit handler : any sql error undoes everything done in this call
declare exit handler for sqlexception
begin
rollback;
set p_message = 'renewal failed : transaction rolled back';
end;

if p_processed_count is null then
set p_processed_count = 0;
end if;

start transaction;

select status, base_premium, current_premium, no_claim_years
into v_status, v_base_premium, v_old_premium, v_no_claim_years
from policies
where policy_id = p_policy_id
for update;

-- validation 1 : policy must exist and be active
if v_status is null then
rollback;
set p_message = 'rejected : policy not found';
leave main;
end if;
if v_status <> 'ACTIVE' then
rollback;
set p_message = concat('rejected : policy is ', v_status);
leave main;
end if;

-- validation 2 : no pending claim
select count(*) into v_pending_claims
from claims
where policy_id = p_policy_id and claim_status = 'PENDING';
if v_pending_claims > 0 then
rollback;
set p_message = 'rejected : policy has a pending claim';
leave main;
end if;

-- premium recalculation : a claim in the last 12 months resets the no claim years
select count(*) into v_recent_claims
from claims
where policy_id = p_policy_id
and claim_date >= date_sub(curdate(), interval 1 year);
if v_recent_claims = 0 then
set v_new_no_claim_years = v_no_claim_years + 1;
else
set v_new_no_claim_years = 0;
end if;
set v_new_premium = fn_premium_with_no_claim_discount(v_base_premium, v_new_no_claim_years);

update policies
set current_premium = v_new_premium,
no_claim_years = v_new_no_claim_years,
renewal_date = date_add(renewal_date, interval 1 year),
premium_paid_until = date_add(premium_paid_until, interval 1 year)
where policy_id = p_policy_id;

-- audit row
insert into policy_audit (policy_id, action, old_premium, new_premium, remarks)
values (p_policy_id, 'RENEWED', v_old_premium, v_new_premium,
concat('no claim years ', v_no_claim_years, ' -> ', v_new_no_claim_years));

commit;
set p_processed_count = p_processed_count + 1;
set p_message = 'policy renewed';
end$$

delimiter ;

-- ---------- task 3 : report that uses the function ----------
select p.policy_id,
c.customer_name,
p.policy_type,
p.no_claim_years,
p.base_premium,
fn_premium_with_no_claim_discount(p.base_premium, p.no_claim_years) as premium_after_discount,
p.base_premium - fn_premium_with_no_claim_discount(p.base_premium, p.no_claim_years) as discount_amount
from policies p
join customers c on c.customer_id = p.customer_id
where p.status = 'ACTIVE'
order by p.policy_id;

-- ---------- test calls : the running count is carried from call to call ----------
set @processed = 0;
call sp_renew_policy(1, @processed, @msg);
select 1 as policy_id, @msg as message, @processed as processed_so_far;
call sp_renew_policy(2, @processed, @msg);
select 2 as policy_id, @msg as message, @processed as processed_so_far;
call sp_renew_policy(3, @processed, @msg);
select 3 as policy_id, @msg as message, @processed as processed_so_far;
call sp_renew_policy(8, @processed, @msg);
select 8 as policy_id, @msg as message, @processed as processed_so_far;
call sp_renew_policy(99, @processed, @msg);
select 99 as policy_id, @msg as message, @processed as processed_so_far;

select * from policy_audit;
select policy_id, status, current_premium, no_claim_years, renewal_date from policies where policy_id in (1,2,3,8);
