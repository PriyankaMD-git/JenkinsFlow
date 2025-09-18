const express = require('express');
const router = express.Router();
const quizController = require('../controllers/quizController');

router.get('/', quizController.getQuiz);
router.post('/', quizController.createQuiz); // ← This line is failing

module.exports = router;