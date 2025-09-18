const express = require('express');
const cors = require('cors');
const app = express();
require('dotenv').config();
const { log } = require('./utils/logger');

// Middleware
app.use(cors()); // ✅ Allow cross-origin requests
app.use(express.json());

// Routes
const quizRoutes = require('./routes/quiz');
app.use('/api/quiz', quizRoutes);

// Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  log(`Backend running on port ${PORT}`);
});