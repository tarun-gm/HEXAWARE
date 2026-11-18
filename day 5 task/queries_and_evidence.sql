use retail_inventory_db;

insert into products (sku, product_name, category_id, supplier_id, unit_price, status) values ('SKU-1001', 'Duplicate Wireless Mouse', 1, 1, 799.00, 'ACTIVE');

insert into products (sku, product_name, category_id, supplier_id, unit_price, status) values ('SKU-9999', 'Orphan Smart Watch', 999, 1, 4999.00, 'ACTIVE');

insert into inventory (sku, warehouse_id, quantity, reorder_level) values ('SKU-1001', 3, -15, 10);

insert into products (sku, product_name, category_id, supplier_id, unit_price, status) values ('SKU-8888', null, 1, 1, 500.00, 'ACTIVE');

select supplier_id, supplier_name, supplier_phone from suppliers where supplier_id = 1;
update suppliers set supplier_phone = '+91-98401-99999' where supplier_id = 1;
select supplier_id, supplier_name, supplier_phone from suppliers where supplier_id = 1;

select sku, product_name, status from products where status = 'DISCONTINUED';
delete from inventory where sku in (select sku from products where status = 'DISCONTINUED');
delete from products where status = 'DISCONTINUED';
select sku, product_name, status from products where status = 'DISCONTINUED';

show databases;

select table_schema, count(*) as system_table_count from information_schema.tables where table_schema in ('information_schema', 'mysql', 'performance_schema', 'sys') group by table_schema order by table_schema;

select table_name, engine, table_rows from information_schema.tables where table_schema = 'retail_inventory_db' order by table_name;
