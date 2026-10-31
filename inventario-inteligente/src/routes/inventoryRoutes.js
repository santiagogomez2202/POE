const express = require('express');
const router = express.Router();
const inventoryController = require('../controllers/inventoryController');

router.post('/add', inventoryController.addStock.bind(inventoryController));
router.post('/remove', inventoryController.removeStock.bind(inventoryController));

module.exports = router;