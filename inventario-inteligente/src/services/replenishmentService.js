const db = require('../config/database');

class ReplenishmentService {
    /**
     * Creates an automatic purchase order when stock is low
     * @param {string} sku - Product SKU
     * @param {number} currentStock - Current stock level
     * @param {number} minStock - Minimum stock threshold
     * @returns {Promise<Object>} Created order details
     */
    async createAutoReplenishmentOrder(sku, currentStock, minStock) {
        // 1. Get product details (including linked supplier if available)
        const [products] = await db.execute(
            'SELECT id_producto, nombre, id_proveedor, stock_minimo FROM productos WHERE sku = ?', 
            [sku]
        );
        
        const product = products[0];
        if (!product) {
            throw new Error(`Product with SKU ${sku} not found`);
        }

        // 2. Calculate reorder quantity (e.g., bring stock up to 2x the minimum threshold)
        const targetStock = minStock * 2;
        const reorderQuantity = targetStock - currentStock;

        // 3. Fallback to a default supplier if the product doesn't have one assigned
        const id_proveedor = product.id_proveedor || 1; 

        // 4. Create the Purchase Order (ordenes_compra)
        const [orderResult] = await db.execute(
            `INSERT INTO ordenes_compra (id_proveedor, fecha_orden, estado, total) 
             VALUES (?, NOW(), 'PENDIENTE', 0.00)`,
            [id_proveedor]
        );
        
        const id_orden_compra = orderResult.insertId;

        // 5. Create the Purchase Order Detail (detalle_orden_compra)
        // Note: precio_unitario is set to 0 for now, to be updated when supplier confirms
        await db.execute(
            `INSERT INTO detalle_orden_compra (id_orden_compra, id_producto, cantidad, precio_unitario) 
             VALUES (?, ?, ?, 0.00)`,
            [id_orden_compra, product.id_producto, reorderQuantity]
        );

        return { 
            id_orden_compra, 
            sku, 
            productName: product.nombre,
            reorderQuantity,
            id_proveedor 
        };
    }
}

module.exports = new ReplenishmentService();