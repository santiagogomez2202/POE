const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');

router.post('/', productController.create.bind(productController));
router.get('/', productController.getAll.bind(productController));

module.exports = router;