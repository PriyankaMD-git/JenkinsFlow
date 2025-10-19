const express = require('express');
const router = express.Router();
const quizController = require('../controllers/quizController');

router.get('/', quizController.getQuiz);
router.post('/', quizController.createQuiz); // ← This is failing

module.exports = router;