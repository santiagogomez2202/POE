const fs = require('fs').promises;
const path = require('path');
const db = require('../src/config/database');

async function runMigrations() {
  try {
    console.log('Starting database migrations...\n');
    
    const migrationsDir = path.join(__dirname, '../database/migrations');
    const files = await fs.readdir(migrationsDir);
    
    // Filter and sort SQL files
    const sqlFiles = files
      .filter(file => file.endsWith('.sql'))
      .sort();
    
    if (sqlFiles.length === 0) {
      console.log('No SQL files found in database/migrations/');
      process.exit(0);
    }

    console.log(`${sqlFiles.length} migrations found\n`);

    // Execute each migration in order
    for (const file of sqlFiles) {
      const filePath = path.join(migrationsDir, file);
      const sql = await fs.readFile(filePath, 'utf8');
      
      process.stdout.write(`Running: ${file} ... `);
      await db.query(sql);
      console.log('DONE');
    }
    
    console.log('\nAll migrations were executed successfully');
    process.exit(0);
  } catch (error) {
    console.error('\nError running migrations:', error.message);
    process.exit(1);
  }
}

runMigrations();