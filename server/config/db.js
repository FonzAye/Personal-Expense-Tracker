const { Pool } = require('pg');
require('dotenv').config(); // Ensure environment variables are loaded

console.log("DB_HOST:", process.env.DB_HOST); // Debugging log

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT || 5432,
  ssl: {
    rejectUnauthorized: false,
  },
});

// Test DB connection
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error("Database connection error:", err);
  } else {
    console.log("Database connected successfully at:", res.rows[0].now);
  }
});

module.exports = pool;
