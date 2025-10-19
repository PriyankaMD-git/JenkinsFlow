const express = require('express');
const cors = require('cors');
const app = express();
require('dotenv').config();
const { log } = require('./utils/logger');

// Middleware
app.use(cors()); //  Allow cross-origin requests
app.use(express.json());

// Routes
const quizRoutes = require('./routes/quiz');
app.use('/api/quiz', quizRoutes);

// Submit route
app.post('/api/submit', (req, res) => {
  const { answers } = req.body;

  // Load quiz data — adjust path if needed
  const quiz = require('./quiz.json'); // Make sure this file exists in the same directory

  if (!answers || typeof answers !== 'object') {
    return res.status(400).json({ error: 'Invalid answers format' });
  }

  let score = 0;

  quiz.questions.forEach((question, index) => {
    if (answers[index] === question.correctAnswer) {
      score++;
    }
  });

  res.json({ score });
});

//  Health check route
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

//  Root route for sanity check
app.get('/', (req, res) => {
  res.send('Backend is running 🚀');
});

// Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  log(`Backend running on port ${PORT}`);
});