CREATE TABLE IF NOT EXISTS purchase_order_details (
    po_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL,
    quantity_ordered INT NOT NULL,
    quantity_received INT DEFAULT 0,
    FOREIGN KEY (purchase_order_id) REFERENCES purchase_orders(purchase_order_id) ON DELETE CASCADE,
    FOREIGN KEY (sku) REFERENCES products(sku),
    INDEX idx_purchase_order (purchase_order_id),
    INDEX idx_sku (sku)
);