const inventoryService = require('../services/inventoryService');

class InventoryController {
    async addStock(req, res, next) {
        try {
            const { sku, cantidad, id_ubicacion, motivo } = req.body;
            const result = await inventoryService.addStock(sku, cantidad, id_ubicacion, motivo);
            res.status(200).json(result);
        } catch (error) {
            next(error);
        }
    }

    async removeStock(req, res, next) {
        try {
            const { sku, cantidad, id_ubicacion, motivo } = req.body;
            const result = await inventoryService.removeStock(sku, cantidad, id_ubicacion, motivo);
            res.status(200).json(result);
        } catch (error) {
            next(error);
        }
    }
}

module.exports = new InventoryController();