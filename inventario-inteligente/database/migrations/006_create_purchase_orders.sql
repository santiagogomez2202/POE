CREATE TABLE IF NOT EXISTS purchase_orders (
    purchase_order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    supplier_id INT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    INDEX idx_status (status),
    INDEX idx_supplier (supplier_id),
    INDEX idx_order_date (order_date)
);
