const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// Phase 2: Import routes
const productRoutes = require('./routes/productRoutes');
const inventoryRoutes = require('./routes/inventoryRoutes');

// Phase 3: Import automation event listeners
const setupAutomationListeners = require('./events/automationListeners');

// Initialize Express app
const app = express();

// --- Middlewares (Phase 1) ---
app.use(helmet()); // Security headers
app.use(cors());   // Enable CORS
app.use(morgan('dev')); // HTTP request logger
app.use(express.json()); // Parse JSON bodies

// --- Health Check Endpoint (Phase 1) ---
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development'
    });
});

// --- Routes Registration (Phase 2) ---
app.use('/api/products', productRoutes);
app.use('/api/inventory', inventoryRoutes);

// --- Phase 3: Automation Setup ---
// This connects the event emitter to the replenishment and notification services
setupAutomationListeners();

// --- Global Error Handler ---
app.use((err, req, res, next) => {
    console.error('[EXPRESS ERROR]', err.message);
    
    // Handle specific known errors gracefully
    if (err.message.includes('not found') || err.message.includes('Insufficient stock')) {
        return res.status(400).json({ error: err.message });
    }
    
    // Default to 500 for unexpected errors
    res.status(500).json({ 
        error: 'Internal Server Error', 
        details: process.env.NODE_ENV === 'development' ? err.message : undefined 
    });
});

// Export the configured app (do not listen here)
module.exports = app;