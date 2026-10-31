require('dotenv').config();

const app = require('./src/app');
const db = require('./src/config/database');

const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

const server = app.listen(PORT, () => {
    console.log('==================================================');
    console.log(` Server is running on port ${PORT}`);
    console.log(` Environment: ${NODE_ENV}`);
    console.log(` API Base URL: http://localhost:${PORT}`);
    console.log('==================================================');
});

process.on('SIGTERM', () => {
    console.log('SIGTERM signal received: closing HTTP server');
    server.close(() => {
        console.log('HTTP server closed');
        db.end(() => {
            console.log('Database pool closed');
            process.exit(0);
        });
    });
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});