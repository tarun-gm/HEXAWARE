-- =====================================================
-- set 2 : insurance premium processing
-- file : views.sql  (run this file first)
-- run order : views.sql -> procedures.sql -> cursor.sql
-- =====================================================
drop database if exists insurance_db;
create database insurance_db;
use insurance_db;

-- ---------- tables ----------
create table customers (
customer_id int primary key,
customer_name varchar(50) not null,
email varchar(60),
phone varchar(15),
national_id varchar(20),
date_of_birth date,
home_address varchar(100)
);
create table policies (
policy_id int primary key,
customer_id int not null,
policy_type varchar(20),
status varchar(10) not null,
start_date date,
renewal_date date,
premium_paid_until date,
base_premium decimal(10,2),
current_premium decimal(10,2),
no_claim_years int default 0,
foreign key (customer_id) references customers(customer_id)
);
create table claims (
claim_id int primary key,
policy_id int not null,
claim_date date,
claim_status varchar(10),
claim_amount decimal(10,2),
foreign key (policy_id) references policies(policy_id)
);
create table policy_audit (
audit_id int auto_increment primary key,
policy_id int,
action varchar(20),
old_premium decimal(10,2),
new_premium decimal(10,2),
remarks varchar(100),
audit_time timestamp default current_timestamp
);
create table lapse_log (
log_id int auto_increment primary key,
policy_id int,
old_status varchar(10),
new_status varchar(10),
logged_by varchar(20),
logged_at timestamp default current_timestamp
);

-- ---------- sample data (dates are relative to today so the demo always works) ----------
insert into customers values
(1,'anita rao','anita@mail.com','9000000001','nid-1001','1985-03-12','12 lake road, chennai'),
(2,'bharat kumar','bharat@mail.com','9000000002','nid-1002','1979-07-01','45 hill street, madurai'),
(3,'chitra devi','chitra@mail.com','9000000003','nid-1003','1990-11-23','8 park avenue, kochi'),
(4,'dev patel','dev@mail.com','9000000004','nid-1004','1988-01-30','27 mg road, pune'),
(5,'esha nair','esha@mail.com','9000000005','nid-1005','1995-05-17','3 beach road, goa'),
(6,'farid khan','farid@mail.com','9000000006','nid-1006','1982-09-09','60 river lane, surat');
insert into policies values
(1,1,'health','ACTIVE',date_sub(curdate(),interval 355 day),date_add(curdate(),interval 10 day),date_add(curdate(),interval 10 day),12000,10200,3),
(2,2,'motor','ACTIVE',date_sub(curdate(),interval 340 day),date_add(curdate(),interval 25 day),date_add(curdate(),interval 25 day),8000,8000,0),
(3,3,'life','ACTIVE',date_sub(curdate(),interval 360 day),date_add(curdate(),interval 5 day),date_add(curdate(),interval 5 day),20000,18000,2),
(4,4,'health','ACTIVE',date_sub(curdate(),interval 320 day),date_add(curdate(),interval 45 day),date_add(curdate(),interval 45 day),9000,9000,0),
(5,5,'motor','ACTIVE',date_sub(curdate(),interval 345 day),date_add(curdate(),interval 20 day),date_sub(curdate(),interval 15 day),7000,7000,0),
(6,6,'life','ACTIVE',date_sub(curdate(),interval 300 day),date_add(curdate(),interval 60 day),date_sub(curdate(),interval 30 day),15000,13500,2),
(7,1,'motor','ACTIVE',date_sub(curdate(),interval 375 day),date_sub(curdate(),interval 10 day),date_sub(curdate(),interval 10 day),6000,6000,0),
(8,2,'health','LAPSED',date_sub(curdate(),interval 350 day),date_add(curdate(),interval 12 day),date_sub(curdate(),interval 60 day),11000,11000,0);
insert into claims values
(1,3,date_sub(curdate(),interval 5 day),'PENDING',45000),
(2,2,date_sub(curdate(),interval 100 day),'SETTLED',12000);

-- =====================================================
-- task 1 : vw_policy_due
-- active policies renewing in the next 30 days, with customer details
-- national_id, date_of_birth and home_address are left out on purpose
-- =====================================================
create or replace view vw_policy_due as
select p.policy_id,
p.policy_type,
p.renewal_date,
datediff(p.renewal_date, curdate()) as days_to_renewal,
p.current_premium,
c.customer_id,
c.customer_name,
c.email,
c.phone
from policies p
join customers c on c.customer_id = p.customer_id
where p.status = 'ACTIVE'
and p.renewal_date between curdate() and date_add(curdate(), interval 30 day);

-- check the view
select * from vw_policy_due order by renewal_date;
