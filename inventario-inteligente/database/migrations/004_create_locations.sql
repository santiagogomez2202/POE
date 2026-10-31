CREATE TABLE IF NOT EXISTS locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    aisle VARCHAR(10),
    rack VARCHAR(10),
    shelf_level VARCHAR(10),
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_aisle_rack (aisle, rack)
);