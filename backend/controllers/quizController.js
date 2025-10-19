exports.getQuiz = (req, res) => {
  const quiz = {
    title: "JavaScript Basics",
    questions: [
      {
        questionText: "What does `typeof null` return?",
        options: ["object", "null", "undefined", "boolean"],
        correctAnswer: "object"
      },
      {
        questionText: "Which method converts JSON to a JavaScript object?",
        options: ["JSON.parse()", "JSON.stringify()", "JSON.convert()", "JSON.toObject()"],
        correctAnswer: "JSON.parse()"
      }
    ]
  };

  res.json(quiz);
};

// ✅ Add this to fix the crash from undefined route handler
exports.createQuiz = (req, res) => {
  const newQuiz = req.body;
  // You can add validation or database logic here later
  res.status(201).json({
    message: "Quiz created successfully",
    quiz: newQuiz
  });
};