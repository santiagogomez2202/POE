const productRepository = require('../repositories/productRepository');
const eventEmitter = require('../events/eventEmitter');

class ProductService {
    async createProduct(productData) {
        // 1. Business logic validation
        const existingProduct = await productRepository.findBySku(productData.sku);
        if (existingProduct) {
            throw new Error('Product with this SKU already exists');
        }

        // 2. Save to database
        await productRepository.create(productData);

        // 3. Emit event for other systems (e.g., logging, notifications)
        eventEmitter.emit('product:created', { 
            sku: productData.sku, 
            nombre: productData.nombre,
            timestamp: new Date().toISOString() 
        });

        return { message: 'Product created successfully', sku: productData.sku };
    }

    async getAllProducts() {
        return await productRepository.findAll();
    }
}

module.exports = new ProductService();