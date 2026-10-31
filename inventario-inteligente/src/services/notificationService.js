class NotificationService {
    /**
     * Sends a low stock alert
     * @param {string} sku - Product SKU
     * @param {number} currentStock - Current stock level
     * @param {number} minStock - Minimum stock threshold
     */
    async sendLowStockAlert(sku, currentStock, minStock) {
        const message = `⚠️ CRITICAL STOCK ALERT: Product SKU '${sku}' has reached critical level. Current: ${currentStock}, Minimum: ${minStock}`;
        
        // TODO: Integrate with external services (e.g., Nodemailer, Slack Webhook)
        console.log(`[NOTIFICATION SERVICE] ${message}`);
        
        return { status: 'sent', type: 'low_stock', sku, timestamp: new Date().toISOString() };
    }

    /**
     * Sends a confirmation when an auto-replenishment order is created
     * @param {number} orderId - Purchase order ID
     * @param {string} sku - Product SKU
     * @param {number} quantity - Reordered quantity
     */
    async sendReplenishmentOrderCreated(orderId, sku, quantity) {
        const message = `✅ REPLENISHMENT ORDER GENERATED: Purchase Order #${orderId} created for ${quantity} units of SKU '${sku}'.`;
        
        console.log(`[NOTIFICATION SERVICE] ${message}`);
        
        return { status: 'sent', type: 'order_created', orderId, timestamp: new Date().toISOString() };
    }
}

module.exports = new NotificationService();