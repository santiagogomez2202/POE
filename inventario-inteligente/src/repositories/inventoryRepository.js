const db = require('../config/database');
class InventoryRepository {
    // Get current stock for a product in a specific location
    async getStock(sku, id_ubicacion = 'ALMACEN_PRINCIPAL') {
        const query = `
            SELECT cantidad FROM inventario 
            WHERE sku = ? AND id_ubicacion = ?
        `;
        const [rows] = await db.execute(query, [sku, id_ubicacion]);
        return rows[0] ? rows[0].cantidad : 0;
    }

    // Update or insert stock (Upsert)
    async updateStock(sku, id_ubicacion, cantidad) {
        const query = `
            INSERT INTO inventario (sku, id_ubicacion, cantidad)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE cantidad = ?
        `;
        await db.execute(query, [sku, id_ubicacion, cantidad, cantidad]);
    }

    // Register a stock movement (Entrada/Salida)
    async registerMovement(sku, tipo_movimiento, cantidad, motivo) {
        const query = `
            INSERT INTO movimientos_inventario (sku, tipo_movimiento, cantidad, motivo)
            VALUES (?, ?, ?, ?)
        `;
        await db.execute(query, [sku, tipo_movimiento, cantidad, motivo]);
    }
}

module.exports = new InventoryRepository();