CREATE TABLE IF NOT EXISTS sales_order_details (
    so_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    sales_order_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL,
    quantity_ordered INT NOT NULL,
    quantity_shipped INT DEFAULT 0,
    FOREIGN KEY (sales_order_id) REFERENCES sales_orders(sales_order_id) ON DELETE CASCADE,
    FOREIGN KEY (sku) REFERENCES products(sku),
    INDEX idx_sales_order (sales_order_id),
    INDEX idx_sku (sku)
);