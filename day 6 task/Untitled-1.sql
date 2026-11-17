set 1


drop database if exists retail_db;
create database retail_db;
use retail_db;

create table customers (
    customer_id int primary key,
    customer_name varchar(100),
    phone varchar(15),
    city varchar(50),
    joined_date date
);

create table products (
    product_id int primary key,
    product_name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    status varchar(30),
    discount decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    order_item_id int primary key,
    order_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

create table payments (
    payment_id int primary key,
    order_id int,
    amount decimal(10,2),
    method varchar(30),
    payment_date date,
    foreign key (order_id) references orders(order_id)
);

insert into customers values
(1, 'Arun Kumar', '9840011111', 'Chennai', '2025-11-10'),
(2, 'Divya Sharma', null, 'Mumbai', '2025-12-05'),
(3, 'Karthik Raj', '9841022222', 'Chennai', '2026-01-15'),
(4, 'Meena Iyer', '9845033333', 'Bengaluru', '2026-01-20'),
(5, 'Rahul Verma', null, 'Delhi', '2026-02-02'),
(6, 'Sneha Nair', '9820044444', 'Mumbai', '2026-02-14'),
(7, 'Vikram Singh', '9811055555', 'Delhi', '2026-03-01'),
(8, 'Priya Menon', '9844066666', 'Bengaluru', '2026-03-10');

insert into products values
(101, 'Laptop', 'Electronics', 55000),
(102, 'Smartphone', 'Electronics', 20000),
(103, 'Headphones', 'Accessories', 2500),
(104, 'Office Chair', 'Furniture', 7000),
(105, 'Notebook Pack', 'Stationery', 300),
(106, 'Desk Lamp', 'Furniture', 1200);

insert into orders values
(1, 1, '2026-03-02', 'delivered', 500),
(2, 1, '2026-03-15', 'delivered', null),
(3, 1, '2026-04-05', 'delivered', 200),
(4, 1, '2026-04-18', 'pending', null),
(5, 2, '2026-03-10', 'delivered', null),
(6, 3, '2026-03-22', 'delivered', 1000),
(7, 3, '2026-04-05', 'pending', null),
(8, 4, '2026-04-12', 'delivered', 1500),
(9, 5, '2026-04-20', 'delivered', null),
(10, 6, '2026-04-25', 'delivered', 100);

insert into order_items values
(1, 1, 101, 1, 55000),
(2, 1, 105, 5, 300),
(3, 2, 103, 2, 2500),
(4, 3, 102, 1, 20000),
(5, 3, 106, 2, 1200),
(6, 4, 105, 10, 300),
(7, 5, 104, 1, 7000),
(8, 6, 102, 2, 20000),
(9, 7, 103, 1, 2500),
(10, 7, 106, 1, 1200),
(11, 8, 101, 1, 55000),
(12, 9, 104, 2, 7000),
(13, 10, 105, 4, 300),
(14, 10, 106, 3, 1200);

insert into payments values
(1, 1, 56500, 'UPI', '2026-03-02'),
(2, 2, 5000, 'Card', '2026-03-15'),
(3, 3, 22400, 'Card', '2026-04-05'),
(4, 5, 7000, 'UPI', '2026-03-10'),
(5, 6, 40000, 'NetBanking', '2026-03-22'),
(6, 8, 55000, 'Card', '2026-04-12'),
(7, 9, 14000, 'UPI', '2026-04-20'),
(8, 10, 4800, 'UPI', '2026-04-25');

 task 1

 use retail_db;

select p.product_name, p.category, sum(oi.quantity * oi.unit_price) as revenue
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name, p.category
order by revenue desc
limit 5;

select date_format(order_date, '%Y-%m') as sales_month, count(distinct orders.order_id) as total_orders, sum(quantity * unit_price) as total_sales
from orders
join order_items on orders.order_id = order_items.order_id
group by sales_month
order by sales_month;

select customers.customer_id, customer_name, count(order_id) as total_orders
from customers
join orders on customers.customer_id = orders.customer_id
group by customers.customer_id, customer_name
having count(order_id) > 3;

select city, count(orders.order_id) as total_orders, round(avg(order_total), 2) as avg_basket_value
from customers
join orders on customers.customer_id = orders.customer_id
join (select order_id, sum(quantity * unit_price) as order_total from order_items group by order_id) as temp on orders.order_id = temp.order_id
group by city;

select orders.order_id, customer_name, order_date, status
from orders
join customers on orders.customer_id = customers.customer_id
left join payments on orders.order_id = payments.order_id
where payments.payment_id is null;

select customers.customer_id, customer_name, city
from customers
left join orders on customers.customer_id = orders.customer_id
where orders.order_id is null;

select category, sum(quantity * unit_price) as category_revenue, round(sum(quantity * unit_price) * 100 / (select sum(quantity * unit_price) from order_items), 2) as revenue_share_pct
from products
join order_items on products.product_id = order_items.product_id
group by category;

select order_date, sum(quantity * unit_price) as daily_sales
from orders
join order_items on orders.order_id = order_items.order_id
group by order_date
order by daily_sales desc
limit 1;

task 2

select concat(upper(customer_name), ' (', city, ')') as customer,
date_format(min(order_date), '%d-%b-%Y') as first_order,
datediff('2026-04-30', max(order_date)) as days_since_last_order,
round(sum(quantity * unit_price) / count(distinct orders.order_id), 2) as avg_order_value
from customers
join orders on customers.customer_id = orders.customer_id
join order_items on orders.order_id = order_items.order_id
group by customers.customer_id, customer_name, city
order by customer_name;

task 3

select count(*) as total_orders,
count(discount) as total_discounts,
sum(discount) as total_discount,
avg(discount) as average_discount,
avg(coalesce(discount, 0)) as average_with_zero
from orders;

select count(*) as total_customers,
count(phone) as total_phones
from customers;

task 4

select customer_name, count(order_id) as april_orders
from customers
join orders on customers.customer_id = orders.customer_id
where order_date >= '2026-04-01' and order_date < '2026-05-01'
group by customers.customer_id, customer_name
having count(order_id) >= 2;
