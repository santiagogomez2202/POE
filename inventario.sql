<<<<<<< HEAD
CREATE DATABASE IF NOT EXISTS cafeteria_inventory;
USE cafeteria_inventory;

-- ===== ESTRUCTURA =====
CREATE TABLE suppliers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  contact VARCHAR(120),
  phone VARCHAR(30)
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  category VARCHAR(60),          -- beverage | dairy | sweetener | packaging | pastry
  unit VARCHAR(20),
  cost_price DECIMAL(10,2) DEFAULT 0,
  current_stock INT NOT NULL DEFAULT 0,
  min_stock INT NOT NULL DEFAULT 0,
  supplier_id INT,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);

CREATE TABLE movements (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  type ENUM('inflow','outflow') NOT NULL,
  quantity INT NOT NULL,
  reason VARCHAR(160),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  stock_at_detection INT NOT NULL,
  min_stock INT NOT NULL,
  resolved TINYINT(1) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- ===== PROVEEDORES DE CAFETERIA =====
INSERT INTO suppliers (name, contact, phone) VALUES
('Highland Coffee Roasters',     'Mr. Ramos',  '55-1111-2222'),  -- 1
('Northern Dairy Distributors',  'Ms. Torres', '55-3333-4444'),  -- 2
('MX Packaging & Disposables',   'Mr. Diaz',   '55-5555-6666'),  -- 3
('La Espiga Bakery',             'Ms. Vega',   '55-7777-8888');  -- 4

-- Solo 3 quedan criticos a proposito: leche(3), vasos(8), galletas(13)
INSERT INTO products (name, category, unit, cost_price, current_stock, min_stock, supplier_id) VALUES
('Espresso ground coffee',   'beverage',    '1kg bag',     180, 12, 8,  1),  -- 1  OK
('Roasted whole bean coffee','beverage',    '1kg bag',     210, 9,  5,  1),  -- 2  OK
('Whole milk',               'dairy',       'Liter',       22,  3,  10, 2),  -- 3  CRITICO
('Oat milk',                 'dairy',       'Liter',       38,  8,  6,  2),  -- 4  OK
('Standard sugar',           'sweetener',   'Kg',          28,  25, 15, 1),  -- 5  OK
('Liquid sweetener',         'sweetener',   '1L bottle',   65,  9,  4,  1),  -- 6  OK
('Vanilla syrup',            'sweetener',   '750ml bottle',90,  5,  3,  1),  -- 7  OK
('12oz disposable cups',     'packaging',   'Pack x50',    45,  4,  20, 3),  -- 8  CRITICO
('Cup lids',                 'packaging',   'Pack x50',    30,  18, 15, 3),  -- 9  OK
('Wooden stirrers',          'packaging',   'Pack x100',   25,  22, 10, 3),  -- 10 OK
('Napkins',                  'packaging',   'Pack x100',   20,  14, 10, 3),  -- 11 OK
('Cup sleeves',              'packaging',   'Pack x50',    35,  12, 8,  3),  -- 12 OK
('Assorted cookies',         'pastry',      '200g bag',    40,  5,  12, 4),  -- 13 CRITICO (perecedero)
('Blueberry muffins',        'pastry',      'Piece',       18,  16, 10, 4);  -- 14 OK

-- Alertas precargadas (coherentes con los criticos de arriba)
INSERT INTO alerts (product_id, stock_at_detection, min_stock, resolved) VALUES
(3, 3, 10, 0),
(8, 4, 20, 0),
(13, 5, 12, 0);

-- Historial para la grafica de la semana (entradas/salidas por dia)
INSERT INTO movements (product_id, type, quantity, reason, created_at) VALUES
(1,'inflow', 15,'Weekly roaster purchase',   DATE_SUB(NOW(),INTERVAL 6 DAY)),
(3,'outflow',7,'Morning shift - lattes',     DATE_SUB(NOW(),INTERVAL 5 DAY)),
(8,'outflow',16,'Event: science fair',       DATE_SUB(NOW(),INTERVAL 4 DAY)),
(13,'outflow',9,'Waste: expired cookies',    DATE_SUB(NOW(),INTERVAL 3 DAY)),
(1,'outflow',3,'Prep of 30 espressos',       DATE_SUB(NOW(),INTERVAL 2 DAY)),
(9,'outflow',4,'Morning shift',              DATE_SUB(NOW(),INTERVAL 1 DAY)),
(3,'outflow',2,'Afternoon shift',            NOW()),
(14,'outflow',5,'Counter sale - muffins',    NOW());
=======
CREATE DATABASE IF NOT EXISTS cafeteria_inventory;
USE cafeteria_inventory;

CREATE TABLE suppliers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  contact VARCHAR(120),
  phone VARCHAR(30)
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  category VARCHAR(60),          -- beverage | dairy | sweetener | packaging | pastry
  unit VARCHAR(20),
  cost_price DECIMAL(10,2) DEFAULT 0,
  current_stock INT NOT NULL DEFAULT 0,
  min_stock INT NOT NULL DEFAULT 0,
  supplier_id INT,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);

CREATE TABLE movements (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  type ENUM('inflow','outflow') NOT NULL,
  quantity INT NOT NULL,
  reason VARCHAR(160),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE TABLE alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  stock_at_detection INT NOT NULL,
  min_stock INT NOT NULL,
  resolved TINYINT(1) DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);


--Migrations

INSERT INTO products (name, category, unit, cost_price, current_stock, min_stock, supplier_id) VALUES


 --Supplier 1: Jalisco Origin Coffee (Specialist in COFFEE)
('American Coffee', 'Coffee', 'cup', 12, 100, 20, 1),
('Double Espresso', 'Coffee', 'cup', 18, 80, 15, 1),
('Cappuccino', 'Coffee', 'cup', 24, 70, 15, 1),
('Caffè Latte', 'Coffee', 'cup', 22, 75, 15, 1),
('Macchiato', 'Coffee', 'cup', 20, 60, 10, 1),
('Mocha', 'Coffee', 'cup', 28, 50, 10, 1),


--Supplier 2: Sweet Temptation Bakery (Specialist in DESSERTS AND BAKERY)
('Butter Croissant', 'Bakery', 'piece', 18, 40, 10, 2),
('Blueberry Muffin', 'Bakery', 'piece', 22, 35, 10, 2),
('Cinnamon Roll', 'Bakery', 'piece', 25, 30, 8, 2),
('Chocolate Cookie', 'Bakery', 'piece', 15, 60, 15, 2),
('Cheesecake', 'Bakery', 'piece', 45, 20, 5, 2),
('Brownie', 'Bakery', 'piece', 28, 35, 8, 2),


 --Supplier 3: Atemajac Valley Dairy (Specialist in DAIRY)
('Whole Milk', 'Dairy', 'liter', 22, 50, 10, 3),
('Lactose-Free Milk', 'Dairy', 'liter', 24, 45, 10, 3),
('Oat Milk', 'Dairy', 'liter', 45, 30, 8, 3),
('Almond Milk', 'Dairy', 'liter', 50, 25, 8, 3),
('Whipping Cream', 'Dairy', 'liter', 65, 20, 5, 3),
('Cream Cheese', 'Dairy', 'kg', 95, 15, 5, 3),


 --Supplier 4: Sayula Tropical Fruits (Specialist in FRUITS AND COLD DRINKS)
('Strawberry', 'Fruits', 'kg', 55, 20, 5, 4),
('Mango', 'Fruits', 'kg', 35, 15, 4, 4),
('Banana', 'Fruits', 'kg', 18, 25, 5, 4),
('Avocado', 'Fruits', 'kg', 45, 18, 5, 4),
('Orange Juice', 'Cold Drinks', 'glass', 30, 25, 5, 4),
('Green Smoothie', 'Cold Drinks', 'glass', 40, 20, 5, 4),


 --Supplier 5: EcoPack Guadalajara (Specialist in DISPOSABLES)
('8oz Paper Cup', 'Disposables', 'piece', 1.5, 1000, 200, 5),
('12oz Paper Cup', 'Disposables', 'piece', 2.0, 800, 200, 5),
('16oz Paper Cup', 'Disposables', 'piece', 2.5, 600, 150, 5),
('Paper Straw', 'Disposables', 'piece', 0.5, 2000, 500, 5),
('12oz Plastic Lid', 'Disposables', 'piece', 1.0, 800, 200, 5),
('Takeaway Box', 'Disposables', 'piece', 3.5, 300, 50, 5),


 --Supplier 6: Sweeteners and Flavorings MX (Specialist in SYRUPS AND TOPPINGS)
('Vanilla Syrup', 'Toppings', 'liter', 85, 15, 3, 6),
('Caramel Syrup', 'Toppings', 'liter', 85, 15, 3, 6),
('Hazelnut Syrup', 'Toppings', 'liter', 90, 12, 3, 6),
('Chocolate Sauce', 'Toppings', 'liter', 75, 18, 5, 6),
('Honey', 'Toppings', 'jar', 110, 10, 3, 6),
('Strawberry Jam', 'Toppings', 'jar', 60, 20, 5, 6),


--Supplier 7: Premium Tea & Infusions (Specialist in TEA AND INFUSIONS)
('Earl Grey Tea', 'Tea', 'cup', 15, 50, 10, 7),
('Green Tea', 'Tea', 'cup', 14, 55, 10, 7),
('Chamomile Tea', 'Tea', 'cup', 12, 50, 10, 7),
('Matcha Latte', 'Tea', 'cup', 28, 40, 10, 7),
('Chai Latte', 'Tea', 'cup', 26, 35, 8, 7),
('Iced Lemon Tea', 'Tea', 'cup', 18, 45, 10, 7);UPDATE products SET category = 'Beverage' WHERE name IN (
    'American Coffee', 'Double Espresso', 'Cappuccino', 'Caffè Latte', 'Macchiato', 'Mocha',
    'Earl Grey Tea', 'Green Tea', 'Chamomile Tea', 'Matcha Latte', 'Chai Latte', 'Iced Lemon Tea',
    'Orange Juice', 'Green Smoothie',
    'Strawberry', 'Mango', 'Banana', 'Avocado'
);


–-Borrar datos en español 


DELETE FROM suppliers 
WHERE name IN (
    'Café de Origen Jalisco', 
    'Dulce Tentación Bakery', 
    'Lácteos del Valle de Atemajac', 
    'Frutas Tropicales de Sayula', 
    'EcoPack Guadalajara', 
    'Endulzantes y Saborizantes MX', 
    'Té & Infusiones Premium'
);


 --datos en inglés


INSERT INTO suppliers (name, contact, phone) VALUES
('Jalisco Origin Coffee', 'John Perez', '33-1247-8932'),
('Sweet Temptation Bakery', 'Mary Gonzalez', '33-2891-4567'),
('Atemajac Valley Dairy', 'Charles Ramirez', '33-3456-7821'),
('Sayula Tropical Fruits', 'Anne Martinez', '33-4782-9103'),
('EcoPack Guadalajara', 'Robert Sanchez', '33-5123-6789'),
('Sweeteners and Flavorings MX', 'Laura Torres', '33-6891-2345'),
('Premium Tea & Infusions', 'James Morales', '33-7234-5678');


DELETE FROM suppliers;


-- Borrar todos los productos
DELETE FROM products;


-- los proveedores
DELETE FROM suppliers;

-- IDs 17
INSERT INTO suppliers (name, contact, phone) VALUES
('Jalisco Origin Coffee', 'John Perez', '33-1247-8932'),
('Sweet Temptation Bakery', 'Mary Gonzalez', '33-2891-4567'),
('Atemajac Valley Dairy', 'Charles Ramirez', '33-3456-7821'),
('Sayula Tropical Fruits', 'Anne Martinez', '33-4782-9103'),
('EcoPack Guadalajara', 'Robert Sanchez', '33-5123-6789'),
('Sweeteners and Flavorings MX', 'Laura Torres', '33-6891-2345'),
('Premium Tea & Infusions', 'James Morales', '33-7234-5678');


-- los productos en inglés


INSERT INTO products (name, category, unit, cost_price, current_stock, min_stock, supplier_id) VALUES
Supplier 1: Jalisco Origin Coffee (Specialist in COFFEE)
('American Coffee', 'Coffee', 'cup', 12, 100, 20, 1),
('Double Espresso', 'Coffee', 'cup', 18, 80, 15, 1),
('Cappuccino', 'Coffee', 'cup', 24, 70, 15, 1),
('Caffè Latte', 'Coffee', 'cup', 22, 75, 15, 1),
('Macchiato', 'Coffee', 'cup', 20, 60, 10, 1),
('Mocha', 'Coffee', 'cup', 28, 50, 10, 1),


 --Supplier 2: Sweet Temptation Bakery (Specialist in DESSERTS AND BAKERY)
('Butter Croissant', 'Bakery', 'piece', 18, 40, 10, 2),
('Blueberry Muffin', 'Bakery', 'piece', 22, 35, 10, 2),
('Cinnamon Roll', 'Bakery', 'piece', 25, 30, 8, 2),
('Chocolate Cookie', 'Bakery', 'piece', 15, 60, 15, 2),
('Cheesecake', 'Bakery', 'piece', 45, 20, 5, 2),
('Brownie', 'Bakery', 'piece', 28, 35, 8, 2),


--Supplier 3: Atemajac Valley Dairy (Specialist in DAIRY)
('Whole Milk', 'Dairy', 'liter', 22, 50, 10, 3),
('Lactose-Free Milk', 'Dairy', 'liter', 24, 45, 10, 3),
('Oat Milk', 'Dairy', 'liter', 45, 30, 8, 3),
('Almond Milk', 'Dairy', 'liter', 50, 25, 8, 3),
('Whipping Cream', 'Dairy', 'liter', 65, 20, 5, 3),
('Cream Cheese', 'Dairy', 'kg', 95, 15, 5, 3),


--Supplier 4: Sayula Tropical Fruits (Specialist in FRUITS AND COLD DRINKS)
('Strawberry', 'Fruits', 'kg', 55, 20, 5, 4),
('Mango', 'Fruits', 'kg', 35, 15, 4, 4),
('Banana', 'Fruits', 'kg', 18, 25, 5, 4),
('Avocado', 'Fruits', 'kg', 45, 18, 5, 4),
('Orange Juice', 'Cold Drinks', 'glass', 30, 25, 5, 4),
('Green Smoothie', 'Cold Drinks', 'glass', 40, 20, 5, 4),


--Supplier 5: EcoPack Guadalajara (Specialist in DISPOSABLES)
('8oz Paper Cup', 'Disposables', 'piece', 1.5, 1000, 200, 5),
('12oz Paper Cup', 'Disposables', 'piece', 2.0, 800, 200, 5),
('16oz Paper Cup', 'Disposables', 'piece', 2.5, 600, 150, 5),
('Paper Straw', 'Disposables', 'piece', 0.5, 2000, 500, 5),
('12oz Plastic Lid', 'Disposables', 'piece', 1.0, 800, 200, 5),
('Takeaway Box', 'Disposables', 'piece', 3.5, 300, 50, 5),


Supplier 6: Sweeteners and Flavorings MX (Specialist in SYRUPS AND TOPPINGS)
('Vanilla Syrup', 'Toppings', 'liter', 85, 15, 3, 6),
('Caramel Syrup', 'Toppings', 'liter', 85, 15, 3, 6),
('Hazelnut Syrup', 'Toppings', 'liter', 90, 12, 3, 6),
('Chocolate Sauce', 'Toppings', 'liter', 75, 18, 5, 6),
('Honey', 'Toppings', 'jar', 110, 10, 3, 6),
('Strawberry Jam', 'Toppings', 'jar', 60, 20, 5, 6),


--Supplier 7: Premium Tea & Infusions (Specialist in TEA AND INFUSIONS)
('Earl Grey Tea', 'Tea', 'cup', 15, 50, 10, 7),
('Green Tea', 'Tea', 'cup', 14, 55, 10, 7),
('Chamomile Tea', 'Tea', 'cup', 12, 50, 10, 7),
('Matcha Latte', 'Tea', 'cup', 28, 40, 10, 7),
('Chai Latte', 'Tea', 'cup', 26, 35, 8, 7),
('Iced Lemon Tea', 'Tea', 'cup', 18, 45, 10, 7);


SELECT id, name FROM suppliers;


-- Primero borra los productos existentes
DELETE FROM products;


-- IDs
INSERT INTO products (name, category, unit, cost_price, current_stock, min_stock, supplier_id) VALUES
-- Supplier 1: Jalisco Origin Coffee (Specialist in COFFEE)
('American Coffee', 'Coffee', 'cup', 12, 100, 20, (SELECT id FROM suppliers WHERE name = 'Jalisco Origin Coffee')),
('Double Espresso', 'Coffee', 'cup', 18, 80, 15, (SELECT id FROM suppliers WHERE name = 'Jalisco Origin Coffee')),
('Cappuccino', 'Coffee', 'cup', 24, 70, 15, (SELECT id FROM suppliers WHERE name = 'Jalisco Origin Coffee')),
('Caffè Latte', 'Coffee', 'cup', 22, 75, 15, (SELECT id FROM suppliers WHERE name = 'Jalisco Origin Coffee')),
('Macchiato', 'Coffee', 'cup', 20, 60, 10, (SELECT id FROM suppliers WHERE name = 'Jalisco Origin Coffee')),
('Mocha', 'Coffee', 'cup', 28, 50, 10, (SELECT id FROM suppliers WHERE name = 'Jalisco Origin Coffee')),


-- Supplier 2: Sweet Temptation Bakery (Specialist in DESSERTS AND BAKERY)
('Butter Croissant', 'Bakery', 'piece', 18, 40, 10, (SELECT id FROM suppliers WHERE name = 'Sweet Temptation Bakery')),
('Blueberry Muffin', 'Bakery', 'piece', 22, 35, 10, (SELECT id FROM suppliers WHERE name = 'Sweet Temptation Bakery')),
('Cinnamon Roll', 'Bakery', 'piece', 25, 30, 8, (SELECT id FROM suppliers WHERE name = 'Sweet Temptation Bakery')),
('Chocolate Cookie', 'Bakery', 'piece', 15, 60, 15, (SELECT id FROM suppliers WHERE name = 'Sweet Temptation Bakery')),
('Cheesecake', 'Bakery', 'piece', 45, 20, 5, (SELECT id FROM suppliers WHERE name = 'Sweet Temptation Bakery')),
('Brownie', 'Bakery', 'piece', 28, 35, 8, (SELECT id FROM suppliers WHERE name = 'Sweet Temptation Bakery')),


-- Supplier 3: Atemajac Valley Dairy (Specialist in DAIRY)
('Whole Milk', 'Dairy', 'liter', 22, 50, 10, (SELECT id FROM suppliers WHERE name = 'Atemajac Valley Dairy')),
('Lactose-Free Milk', 'Dairy', 'liter', 24, 45, 10, (SELECT id FROM suppliers WHERE name = 'Atemajac Valley Dairy')),
('Oat Milk', 'Dairy', 'liter', 45, 30, 8, (SELECT id FROM suppliers WHERE name = 'Atemajac Valley Dairy')),
('Almond Milk', 'Dairy', 'liter', 50, 25, 8, (SELECT id FROM suppliers WHERE name = 'Atemajac Valley Dairy')),
('Whipping Cream', 'Dairy', 'liter', 65, 20, 5, (SELECT id FROM suppliers WHERE name = 'Atemajac Valley Dairy')),
('Cream Cheese', 'Dairy', 'kg', 95, 15, 5, (SELECT id FROM suppliers WHERE name = 'Atemajac Valley Dairy')),


-- Supplier 4: Sayula Tropical Fruits (Specialist in FRUITS AND COLD DRINKS)
('Strawberry', 'Fruits', 'kg', 55, 20, 5, (SELECT id FROM suppliers WHERE name = 'Sayula Tropical Fruits')),
('Mango', 'Fruits', 'kg', 35, 15, 4, (SELECT id FROM suppliers WHERE name = 'Sayula Tropical Fruits')),
('Banana', 'Fruits', 'kg', 18, 25, 5, (SELECT id FROM suppliers WHERE name = 'Sayula Tropical Fruits')),
('Avocado', 'Fruits', 'kg', 45, 18, 5, (SELECT id FROM suppliers WHERE name = 'Sayula Tropical Fruits')),
('Orange Juice', 'Cold Drinks', 'glass', 30, 25, 5, (SELECT id FROM suppliers WHERE name = 'Sayula Tropical Fruits')),
('Green Smoothie', 'Cold Drinks', 'glass', 40, 20, 5, (SELECT id FROM suppliers WHERE name = 'Sayula Tropical Fruits')),


-- Supplier 5: EcoPack Guadalajara (Specialist in DISPOSABLES)
('8oz Paper Cup', 'Disposables', 'piece', 1.5, 1000, 200, (SELECT id FROM suppliers WHERE name = 'EcoPack Guadalajara')),
('12oz Paper Cup', 'Disposables', 'piece', 2.0, 800, 200, (SELECT id FROM suppliers WHERE name = 'EcoPack Guadalajara')),
('16oz Paper Cup', 'Disposables', 'piece', 2.5, 600, 150, (SELECT id FROM suppliers WHERE name = 'EcoPack Guadalajara')),
('Paper Straw', 'Disposables', 'piece', 0.5, 2000, 500, (SELECT id FROM suppliers WHERE name = 'EcoPack Guadalajara')),
('12oz Plastic Lid', 'Disposables', 'piece', 1.0, 800, 200, (SELECT id FROM suppliers WHERE name = 'EcoPack Guadalajara')),
('Takeaway Box', 'Disposables', 'piece', 3.5, 300, 50, (SELECT id FROM suppliers WHERE name = 'EcoPack Guadalajara')),


-- Supplier 6: Sweeteners and Flavorings MX (Specialist in SYRUPS AND TOPPINGS)
('Vanilla Syrup', 'Toppings', 'liter', 85, 15, 3, (SELECT id FROM suppliers WHERE name = 'Sweeteners and Flavorings MX')),
('Caramel Syrup', 'Toppings', 'liter', 85, 15, 3, (SELECT id FROM suppliers WHERE name = 'Sweeteners and Flavorings MX')),
('Hazelnut Syrup', 'Toppings', 'liter', 90, 12, 3, (SELECT id FROM suppliers WHERE name = 'Sweeteners and Flavorings MX')),
('Chocolate Sauce', 'Toppings', 'liter', 75, 18, 5, (SELECT id FROM suppliers WHERE name = 'Sweeteners and Flavorings MX')),
('Honey', 'Toppings', 'jar', 110, 10, 3, (SELECT id FROM suppliers WHERE name = 'Sweeteners and Flavorings MX')),
('Strawberry Jam', 'Toppings', 'jar', 60, 20, 5, (SELECT id FROM suppliers WHERE name = 'Sweeteners and Flavorings MX')),


-- Supplier 7: Premium Tea & Infusions (Specialist in TEA AND INFUSIONS)
('Earl Grey Tea', 'Tea', 'cup', 15, 50, 10, (SELECT id FROM suppliers WHERE name = 'Premium Tea & Infusions')),
('Green Tea', 'Tea', 'cup', 14, 55, 10, (SELECT id FROM suppliers WHERE name = 'Premium Tea & Infusions')),
('Chamomile Tea', 'Tea', 'cup', 12, 50, 10, (SELECT id FROM suppliers WHERE name = 'Premium Tea & Infusions')),
('Matcha Latte', 'Tea', 'cup', 28, 40, 10, (SELECT id FROM suppliers WHERE name = 'Premium Tea & Infusions')),
('Chai Latte', 'Tea', 'cup', 26, 35, 8, (SELECT id FROM suppliers WHERE name = 'Premium Tea & Infusions')),
('Iced Lemon Tea', 'Tea', 'cup', 18, 45, 10, (SELECT id FROM suppliers WHERE name = 'Premium Tea & Infusions'));




UPDATE products SET category = 'Dairy' WHERE name IN (
    'Whole Milk', 'Lactose-Free Milk', 'Oat Milk', 'Almond Milk', 'Whipping Cream', 'Cream Cheese'
);


UPDATE products SET category = 'Pastry' WHERE name IN (
    'Butter Croissant', 'Blueberry Muffin', 'Cinnamon Roll', 'Chocolate Cookie', 'Cheesecake', 'Brownie'
);


UPDATE products SET category = 'Sweetener' WHERE name IN (
    'Vanilla Syrup', 'Caramel Syrup', 'Hazelnut Syrup', 'Chocolate Sauce', 'Honey', 'Strawberry Jam'
);


UPDATE products SET category = 'Packaging' WHERE name IN (
    '8oz Paper Cup', '12oz Paper Cup', '16oz Paper Cup', 'Paper Straw', '12oz Plastic Lid', 'Takeaway Box'
);


 --Actualizar Bebidas
UPDATE products SET category = 'beverage' WHERE category IN ('Coffee', 'Tea', 'Cold Drinks', 'Fruits');


--Actualizar Lácteos
UPDATE products SET category = 'dairy' WHERE category = 'Dairy';


--Actualizar Panadería
UPDATE products SET category = 'pastry' WHERE category = 'Bakery';


--Actualizar Endulzantes y Toppings
UPDATE products SET category = 'sweetener' WHERE category = 'Toppings';


--Actualizar Desechables / Empaques
UPDATE products SET category = 'packaging' WHERE category = 'Disposables';


UPDATE products SET category = LOWER(category);
>>>>>>> b88b5f4 (cambios y migraciones a la base de datos)
