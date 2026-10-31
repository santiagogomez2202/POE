
const eventEmitter = require('../config/events'); 

// Create a centralized event emitter instance
class InventoryEventEmitter extends EventEmitter {
    constructor() {
        super();
        // Set max listeners to avoid memory leak warnings
        this.setMaxListeners(50);
    }
}

// Export a singleton instance
const eventEmitter = new InventoryEventEmitter();

module.exports = eventEmitter;