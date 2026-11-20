-- =====================================================
-- set 3 : retail returns and refunds
-- file : advanced_reports.sql
-- run in mysql workbench from the first line to the last line
-- =====================================================
drop database if exists retail_db;
create database retail_db;
use retail_db;

-- ---------- tables ----------
create table stores (
store_id int primary key,
store_name varchar(50),
region varchar(30)
);
create table employees (
emp_id int primary key,
emp_name varchar(50),
manager_id int,
store_id int,
foreign key (manager_id) references employees(emp_id),
foreign key (store_id) references stores(store_id)
);
create table products (
product_id int primary key,
product_name varchar(50)
);
create table customers (
customer_id int primary key,
customer_name varchar(50)
);
create table sales (
sale_id int primary key,
product_id int,
customer_id int,
store_id int,
sale_date date,
sale_amount decimal(10,2),
foreign key (product_id) references products(product_id),
foreign key (customer_id) references customers(customer_id),
foreign key (store_id) references stores(store_id)
);
create table product_returns (
return_id int primary key,
sale_id int,
return_date date,
reason varchar(40),
foreign key (sale_id) references sales(sale_id)
);
create table refunds (
refund_id int primary key,
return_id int,
refund_amount decimal(10,2),
refund_date date,
foreign key (return_id) references product_returns(return_id)
);

-- ---------- sample data ----------
insert into stores values
(1,'chennai central','south'),
(2,'madurai','south'),
(3,'kochi','south'),
(4,'pune','west'),
(5,'surat','west');
insert into employees values
(1,'asha',null,1),
(2,'bala',1,1),
(3,'chitra',1,2),
(4,'deepak',null,3),
(5,'esha',4,3),
(6,'farhan',null,4),
(7,'gita',6,4),
(8,'hari',6,5);
insert into products values
(1,'tablet'),
(2,'smartwatch'),
(3,'speaker'),
(4,'charger'),
(5,'backpack');
insert into customers values
(1,'ishaan'),
(2,'jaya'),
(3,'kabir'),
(4,'leela'),
(5,'manoj'),
(6,'nisha');
insert into sales values
(401,1,1,1,'2026-02-01',30000),
(402,1,2,1,'2026-02-02',30000),
(403,1,3,2,'2026-02-03',30000),
(404,1,4,3,'2026-02-04',30000),
(405,2,1,1,'2026-02-05',12000),
(406,2,5,2,'2026-02-06',12000),
(407,2,6,4,'2026-02-07',12000),
(408,3,2,2,'2026-02-08',4000),
(409,3,3,3,'2026-02-09',4000),
(410,3,4,4,'2026-02-10',4000),
(411,3,5,5,'2026-02-11',4000),
(412,4,1,1,'2026-02-12',800),
(413,4,6,5,'2026-02-13',800),
(414,4,2,4,'2026-02-14',800),
(415,4,3,5,'2026-02-15',800),
(416,4,4,1,'2026-02-16',800),
(417,5,5,3,'2026-02-17',1500),
(418,5,6,2,'2026-02-18',1500);
insert into product_returns values
(501,401,'2026-02-10','defective'),
(502,402,'2026-02-11','defective'),
(503,403,'2026-02-12','changed mind'),
(504,405,'2026-02-14','defective'),
(505,406,'2026-02-15','not as described'),
(506,408,'2026-02-17','defective'),
(507,410,'2026-02-19','damaged'),
(508,411,'2026-02-20','changed mind'),
(509,412,'2026-03-01','defective'),
(510,413,'2026-03-02','damaged');
-- returns 503, 505, 508 and 510 have no refund
-- refund 607 is a goodwill refund that is not linked to any return (return_id is null)
insert into refunds values
(601,501,30000,'2026-02-12'),
(602,502,28000,'2026-02-13'),
(603,504,12000,'2026-02-16'),
(604,506,4000,'2026-02-18'),
(605,507,3500,'2026-02-21'),
(606,509,800,'2026-03-02'),
(607,null,500,'2026-03-05');

-- view : total refund of every store (stores with no refund show 0)
create view store_refund as
select st.store_id, st.store_name, st.region,
coalesce(sum(f.refund_amount),0) as total_refund
from stores st
left join sales s on s.store_id = st.store_id
left join product_returns r on r.sale_id = s.sale_id
left join refunds f on f.return_id = r.return_id
group by st.store_id, st.store_name, st.region;

-- =====================================================
-- task 1 : ten questions
-- =====================================================

-- q1 : products with a return rate above 10 percent
select p.product_name,
count(distinct s.sale_id) as units_sold,
count(r.return_id) as units_returned,
round(count(r.return_id) * 100.0 / count(distinct s.sale_id), 2) as return_rate_pct
from products p
join sales s on s.product_id = p.product_id
left join product_returns r on r.sale_id = s.sale_id
group by p.product_id, p.product_name
having count(r.return_id) * 100.0 / count(distinct s.sale_id) > 10
order by return_rate_pct desc;

-- q2 : customers who returned something but never got a refund
select c.customer_name
from customers c
where exists (select 1 from sales s
join product_returns r on r.sale_id = s.sale_id
where s.customer_id = c.customer_id)
and not exists (select 1 from sales s
join product_returns r on r.sale_id = s.sale_id
join refunds f on f.return_id = r.return_id
where s.customer_id = c.customer_id)
order by c.customer_name;

-- q3 : store with the highest refund value
select store_name, total_refund
from store_refund
where total_refund = (select max(total_refund) from store_refund);

-- q4 : employees and their managers
select e.emp_name as employee,
coalesce(m.emp_name, 'no manager') as manager,
st.store_name
from employees e
left join employees m on m.emp_id = e.manager_id
left join stores st on st.store_id = e.store_id
order by e.emp_id;

-- q5 : total refund for each region
select region, sum(total_refund) as region_refund
from store_refund
group by region
order by region_refund desc;

-- q6 : refund count and value for each month
select extract(year from refund_date) as refund_year,
extract(month from refund_date) as refund_month,
count(*) as refund_count,
sum(refund_amount) as refund_value
from refunds
group by extract(year from refund_date), extract(month from refund_date)
order by refund_year, refund_month;

-- q7 : return reasons from most to least common
select reason, count(*) as total_returns
from product_returns
group by reason
order by total_returns desc, reason;

-- q8 : customers with more than one return
select c.customer_name, count(r.return_id) as total_returns
from customers c
join sales s on s.customer_id = c.customer_id
join product_returns r on r.sale_id = s.sale_id
group by c.customer_id, c.customer_name
having count(r.return_id) > 1
order by total_returns desc, c.customer_name;

-- q9 : products that were sold but never returned
select p.product_name
from products p
where exists (select 1 from sales s where s.product_id = p.product_id)
and not exists (select 1 from sales s
join product_returns r on r.sale_id = s.sale_id
where s.product_id = p.product_id);

-- q10 : customers ranked by total refund received
select c.customer_name,
coalesce(sum(f.refund_amount), 0) as total_refund,
rank() over (order by coalesce(sum(f.refund_amount), 0) desc) as refund_rank
from customers c
left join sales s on s.customer_id = c.customer_id
left join product_returns r on r.sale_id = s.sale_id
left join refunds f on f.return_id = r.return_id
group by c.customer_id, c.customer_name
order by refund_rank, c.customer_name;

-- =====================================================
-- task 2 : null pitfall of not in, corrected with not exists
-- refunds.return_id holds one null value (refund 607)
-- =====================================================

-- wrong : not in returns no rows because the list contains null
select return_id, sale_id, reason
from product_returns
where return_id not in (select return_id from refunds);

-- correct : not exists returns the returns that really have no refund
select r.return_id, r.sale_id, r.reason
from product_returns r
where not exists (select 1 from refunds f where f.return_id = r.return_id)
order by r.return_id;

-- =====================================================
-- task 3 : any and all (store refund against other stores of the same region)
-- =====================================================

-- greater than all : the highest refund store of its region
select a.store_name, a.region, a.total_refund
from store_refund a
where a.total_refund > all (select b.total_refund from store_refund b
where b.region = a.region and b.store_id <> a.store_id)
order by a.region;

-- greater than any : stores that beat at least one other store of the region
select a.store_name, a.region, a.total_refund
from store_refund a
where a.total_refund > any (select b.total_refund from store_refund b
where b.region = a.region and b.store_id <> a.store_id)
order by a.region, a.total_refund desc;

-- less than all : stores below every other store of the region
select a.store_name, a.region, a.total_refund
from store_refund a
where a.total_refund < all (select b.total_refund from store_refund b
where b.region = a.region and b.store_id <> a.store_id)
order by a.region;

-- =====================================================
-- task 4 : two nested subqueries with execution results
-- =====================================================

-- nested query 1 : customers who bought from the store with the highest refund value
select customer_name
from customers
where customer_id in (
select customer_id from sales
where store_id in (
select store_id from store_refund
where total_refund = (select max(total_refund) from store_refund)
)
)
order by customer_name;

-- nested query 2 : products whose return count is above the average return count
select product_name
from products
where product_id in (
select s.product_id from sales s
where s.sale_id in (select sale_id from product_returns)
group by s.product_id
having count(*) > (
select avg(return_count) from (
select count(*) as return_count
from sales s2
join product_returns r2 on r2.sale_id = s2.sale_id
group by s2.product_id
) as product_return_counts
)
)
order by product_name;

-- execution result of nested query 1 :
-- customer_name
-- ishaan
-- jaya
-- leela

-- execution result of nested query 2 (average return count = 2.5) :
-- product_name
-- speaker
-- tablet
