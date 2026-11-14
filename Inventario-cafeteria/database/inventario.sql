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
