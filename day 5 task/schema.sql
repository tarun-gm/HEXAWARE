drop database if exists retail_inventory_db;
create database retail_inventory_db;
use retail_inventory_db;

create table categories (
category_id int auto_increment primary key,
category_name varchar(100) not null unique,
description varchar(255) default 'General retail merchandise'
) engine=innodb;

create table suppliers (
supplier_id int auto_increment primary key,
supplier_name varchar(150) not null,
supplier_phone varchar(20) not null unique,
contact_email varchar(120)
) engine=innodb;

create table warehouses (
warehouse_id int auto_increment primary key,
warehouse_name varchar(100) not null unique,
location varchar(150) not null
) engine=innodb;

create table products (
sku varchar(30) primary key,
product_name varchar(150) not null,
category_id int not null,
supplier_id int not null,
unit_price decimal(10, 2) not null default 0.00,
status varchar(20) not null default 'ACTIVE',
constraint chk_unit_price check (unit_price >= 0),
constraint fk_products_category foreign key (category_id) references categories(category_id) on delete restrict on update cascade,
constraint fk_products_supplier foreign key (supplier_id) references suppliers(supplier_id) on delete restrict on update cascade
) engine=innodb;

create table inventory (
inventory_id int auto_increment primary key,
sku varchar(30) not null,
warehouse_id int not null,
quantity int not null default 0,
reorder_level int not null default 10,
constraint uq_sku_warehouse unique (sku, warehouse_id),
constraint chk_inventory_quantity check (quantity >= 0),
constraint chk_reorder_level check (reorder_level >= 0),
constraint fk_inventory_product foreign key (sku) references products(sku) on delete restrict on update cascade,
constraint fk_inventory_warehouse foreign key (warehouse_id) references warehouses(warehouse_id) on delete restrict on update cascade
) engine=innodb;
