CREATE TABLE IF NOT EXISTS inventory_movements (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(50) NOT NULL,
    location_id INT NOT NULL,
    quantity INT NOT NULL,
    movement_type ENUM('receiving', 'shipping', 'transfer', 'adjustment') NOT NULL,
    reference_type VARCHAR(50),
    reference_id INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (sku) REFERENCES products(sku),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    INDEX idx_sku (sku),
    INDEX idx_location (location_id),
    INDEX idx_movement_type (movement_type),
    INDEX idx_created_at (created_at),
    INDEX idx_reference (reference_type, reference_id)
);