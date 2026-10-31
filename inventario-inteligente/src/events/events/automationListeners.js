const eventEmitter = require('./eventEmitter'); // Asegúrate de que la ruta coincida con tu EventEmitter
const replenishmentService = require('../services/replenishmentService');
const notificationService = require('../services/notificationService');

/**
 * Sets up all automation event listeners
 */
function setupAutomationListeners() {
    // Listen for stock updates emitted by Phase 2 (inventoryService)
    eventEmitter.on('stock:updated', async (data) => {
        /* 
         * Expected data payload from Phase 2:
         * { sku, id_ubicacion, newStock, tipo: 'ENTRADA' | 'SALIDA', isLowStock: boolean, minStock: number }
         */

        // Only trigger automation on stock OUT (sales/usage) that hits the critical threshold
        if (data.tipo === 'SALIDA' && data.isLowStock) {
            console.log(`[AUTOMATION] Low stock detected for SKU: ${data.sku}. Current: ${data.newStock}, Min: ${data.minStock}`);
            
            try {
                // Step 1: Notify the team
                await notificationService.sendLowStockAlert(data.sku, data.newStock, data.minStock);
                
                // Step 2: Automatically generate a replenishment order
                const order = await replenishmentService.createAutoReplenishmentOrder(
                    data.sku, 
                    data.newStock, 
                    data.minStock
                );
                
                // Step 3: Notify that the order was successfully created
                if (order) {
                    await notificationService.sendReplenishmentOrderCreated(
                        order.id_orden_compra, 
                        data.sku, 
                        order.reorderQuantity
                    );
                }
            } catch (error) {
                console.error(`[AUTOMATION ERROR] Failed to process low stock for SKU ${data.sku}:`, error.message);
                // Optional: Send a failure notification to an admin channel
            }
        }
    });

    console.log('[EVENTS] Automation listeners successfully registered.');
}

module.exports = setupAutomationListeners;