const productService = require('../services/productService');

class ProductController {
    async create(req, res, next) {
        try {
            const result = await productService.createProduct(req.body);
            res.status(201).json(result);
        } catch (error) {
            next(error); // Pass to error handling middleware
        }
    }

    async getAll(req, res, next) {
        try {
            const products = await productService.getAllProducts();
            res.status(200).json(products);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new ProductController();