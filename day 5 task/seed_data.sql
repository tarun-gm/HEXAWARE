use retail_inventory_db;

insert into categories (category_name, description) values
('Electronics', 'Consumer electronics, gadgets, and accessories'),
('Home Appliances', 'Kitchen and household electrical appliances'),
('Furniture', 'Office and home seating, desks, and storage'),
('Stationery', 'Office supplies, paper goods, and writing tools'),
('Apparel', 'Mens and womens casual and formal clothing'),
('Footwear', 'Athletic, casual, and formal shoes'),
('Groceries', 'Packaged dry foods, grains, and beverages'),
('Personal Care', 'Skincare, haircare, and hygiene essentials'),
('Sports & Fitness', 'Exercise gear, mats, and outdoor equipment'),
('Automotive', 'Car care accessories, oils, and replacement parts');

insert into suppliers (supplier_name, supplier_phone, contact_email) values
('Apex Tech Distributors', '+91-98401-11001', 'orders@apextech.in'),
('HomeStyle Appliances Ltd', '+91-98401-11002', 'sales@homestyle.in'),
('UrbanWood Furnishings', '+91-98401-11003', 'supply@urbanwood.in'),
('PaperCraft Office Supplies', '+91-98401-11004', 'desk@papercraft.in'),
('VogueThread Garments', '+91-98401-11005', 'b2b@voguethread.in'),
('StrideRight Footwear Co', '+91-98401-11006', 'orders@strideright.in'),
('FreshHarvest Foods', '+91-98401-11007', 'supply@freshharvest.in'),
('PureGlow Wellness', '+91-98401-11008', 'trade@pureglow.in'),
('ProFit Sports Gear', '+91-98401-11009', 'dispatch@profitsports.in'),
('AutoCare Solutions', '+91-98401-11010', 'support@autocaresol.in');

insert into warehouses (warehouse_name, location) values
('WH-North-01', 'Chennai - Ambattur Industrial Estate'),
('WH-South-02', 'Chennai - Tambaram Logistics Park'),
('WH-Central-03', 'Bengaluru - Peenya Hub'),
('WH-West-04', 'Mumbai - Bhiwandi Depot'),
('WH-East-05', 'Kolkata - Dankuni Freight Center'),
('WH-NCR-06', 'Gurugram - Manesar Zone'),
('WH-Hyd-07', 'Hyderabad - Shamshabad Hub'),
('WH-Pune-08', 'Pune - Chakan Industrial Area'),
('WH-Kochi-09', 'Kochi - Kalamassery Depot'),
('WH-Coimbatore-10', 'Coimbatore - Peelamedu Hub');

insert into products (sku, product_name, category_id, supplier_id, unit_price, status) values
('SKU-1001', 'Wireless Optical Mouse', 1, 1, 799.00, 'ACTIVE'),
('SKU-1002', 'Mechanical Gaming Keyboard', 1, 1, 3499.00, 'ACTIVE'),
('SKU-1003', '1.8L Electric Kettle', 2, 2, 1250.00, 'ACTIVE'),
('SKU-1004', 'Ergonomic Mesh Office Chair', 3, 3, 6800.00, 'ACTIVE'),
('SKU-1005', 'A4 Copier Paper Ream (500 Sheets)', 4, 4, 320.00, 'ACTIVE'),
('SKU-1006', 'Cotton Crew Neck T-Shirt', 5, 5, 499.00, 'ACTIVE'),
('SKU-1007', 'Running Sneakers Pro', 6, 6, 2799.00, 'ACTIVE'),
('SKU-1008', 'Organic Basmati Rice 5kg', 7, 7, 650.00, 'ACTIVE'),
('SKU-1009', 'Aloe Vera Moisturizing Gel', 8, 8, 240.00, 'ACTIVE'),
('SKU-1010', 'Anti-Slip Yoga Mat 6mm', 9, 9, 899.00, 'ACTIVE'),
('SKU-1011', 'Wired Ball Mouse (Legacy)', 1, 1, 250.00, 'DISCONTINUED'),
('SKU-1012', 'Halogen Room Heater (Old Model)', 2, 2, 1400.00, 'DISCONTINUED');

insert into inventory (sku, warehouse_id, quantity, reorder_level) values
('SKU-1001', 1, 120, 25),
('SKU-1002', 1, 45, 10),
('SKU-1003', 2, 60, 15),
('SKU-1004', 3, 18, 5),
('SKU-1005', 4, 300, 50),
('SKU-1006', 5, 150, 30),
('SKU-1007', 6, 80, 20),
('SKU-1008', 7, 200, 40),
('SKU-1009', 8, 95, 20),
('SKU-1010', 9, 70, 15),
('SKU-1011', 1, 0, 5),
('SKU-1012', 2, 0, 5);
