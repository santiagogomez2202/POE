const db = require('../config/database'); // Asumimos que tienes tu conexión MySQL configurada aquí

class ProductRepository {
    // Create a new product
    async create(productData) {
        const { sku, nombre, descripcion, precio, stock_minimo } = productData;
        const query = `
            INSERT INTO productos (sku, nombre, descripcion, precio, stock_minimo)
            VALUES (?, ?, ?, ?, ?)
        `;
        const [result] = await db.execute(query, [sku, nombre, descripcion, precio, stock_minimo]);
        return result;
    }

    // Get product by SKU
    async findBySku(sku) {
        const query = `SELECT * FROM productos WHERE sku = ?`;
        const [rows] = await db.execute(query, [sku]);
        return rows[0] || null;
    }

    // Get all products
    async findAll() {
        const query = `SELECT * FROM productos`;
        const [rows] = await db.execute(query);
        return rows;
    }

    // Update product details
    async update(sku, productData) {
        const { nombre, descripcion, precio, stock_minimo } = productData;
        const query = `
            UPDATE productos 
            SET nombre = ?, descripcion = ?, precio = ?, stock_minimo = ?
            WHERE sku = ?
        `;
        const [result] = await db.execute(query, [nombre, descripcion, precio, stock_minimo, sku]);
        return result;
    }

    // Delete product
    async delete(sku) {
        const query = `DELETE FROM productos WHERE sku = ?`;
        const [result] = await db.execute(query, [sku]);
        return result;
    }
}

module.exports = new ProductRepository();