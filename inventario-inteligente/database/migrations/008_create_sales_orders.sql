CREATE TABLE IF NOT EXISTS sales_orders (
    sales_order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    customer_id INT NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_status (status),
    INDEX idx_customer (customer_id),
    INDEX idx_order_date (order_date)
);