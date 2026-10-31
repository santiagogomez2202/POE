CREATE TABLE IF NOT EXISTS inventory (
    sku VARCHAR(50),
    location_id INT,
    total_quantity INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (sku, location_id),
    FOREIGN KEY (sku) REFERENCES products(sku) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
    INDEX idx_sku (sku),
    INDEX idx_location (location_id)
);