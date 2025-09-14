// Handles logic for quiz routes

exports.getQuiz = (req, res) => {
  res.json({ message: 'Quiz data fetched successfully' });
};

exports.createQuiz = (req, res) => {
  const { title, questions } = req.body;
  // You’d normally validate and save to DB here
  res.status(201).json({ message: 'Quiz created', data: { title, questions } });
};