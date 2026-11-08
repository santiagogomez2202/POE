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