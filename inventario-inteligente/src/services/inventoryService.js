const inventoryRepository = require('../repositories/inventoryRepository');
const productRepository = require('../repositories/productRepository');
const eventEmitter = require('../events/eventEmitter');

class InventoryService {
    async addStock(sku, cantidad, id_ubicacion = 'ALMACEN_PRINCIPAL', motivo = 'Reabastecimiento') {
        const product = await productRepository.findBySku(sku);
        if (!product) throw new Error('Product not found');

        const currentStock = await inventoryRepository.getStock(sku, id_ubicacion);
        const newStock = currentStock + cantidad;

        // Execute DB operations
        await inventoryRepository.updateStock(sku, id_ubicacion, newStock);
        await inventoryRepository.registerMovement(sku, 'ENTRADA', cantidad, motivo);

        // Emit event
        eventEmitter.emit('stock:updated', { 
            sku, 
            id_ubicacion, 
            newStock, 
            tipo: 'ENTRADA',
            timestamp: new Date().toISOString() 
        });

        return { message: 'Stock added successfully', newStock };
    }

    async removeStock(sku, cantidad, id_ubicacion = 'ALMACEN_PRINCIPAL', motivo = 'Venta') {
        const product = await productRepository.findBySku(sku);
        if (!product) throw new Error('Product not found');

        const currentStock = await inventoryRepository.getStock(sku, id_ubicacion);
        if (currentStock < cantidad) {
            throw new Error('Insufficient stock for this operation');
        }

        const newStock = currentStock - cantidad;

        await inventoryRepository.updateStock(sku, id_ubicacion, newStock);
        await inventoryRepository.registerMovement(sku, 'SALIDA', cantidad, motivo);

        // Emit event (Crucial for Phase 3: Auto-replenishment detection)
        eventEmitter.emit('stock:updated', { 
            sku, 
            id_ubicacion, 
            newStock, 
            tipo: 'SALIDA',
            isLowStock: newStock <= product.stock_minimo,
            timestamp: new Date().toISOString() 
        });

        return { message: 'Stock removed successfully', newStock };
    }
}

module.exports = new InventoryService();