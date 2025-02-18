const pool = require('../config/db');

const addExpense = async (req, res) => {
  const { user_id, amount, category, date, description } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO Expenses (user_id, amount, category, date, description) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [user_id, amount, category, date, description]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error adding expense' });
  }
};

const getExpensesByUser = async (req, res) => {
    const { user_id } = req.params;
  
    try {
      const result = await pool.query('SELECT * FROM Expenses WHERE user_id = $1', [user_id]);
      res.status(200).json(result.rows);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error fetching expenses' });
    }
  };
  
  module.exports = { addExpense, getExpensesByUser };