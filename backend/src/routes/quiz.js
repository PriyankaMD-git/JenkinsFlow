const express = require('express');
const router = express.Router();
const { getQuiz, createQuiz } = require('../controllers/quizController');

// GET /api/quiz
router.get('/', getQuiz);

// POST /api/quiz
router.post('/', createQuiz);

module.exports = router;