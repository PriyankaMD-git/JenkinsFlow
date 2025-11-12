import React, { useEffect, useState } from 'react';

const API_BASE = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

function App() {
  const [quiz, setQuiz] = useState(null);
  const [answers, setAnswers] = useState({});
  const [error, setError] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [score, setScore] = useState(null);

  useEffect(() => {
    fetch(`${API_BASE}/quiz`)
      .then(res => res.json())
      .then(data => setQuiz(data))
      .catch(() => setError('Failed to load quiz'));
  }, []);

  const handleSelect = (questionIndex, option) => {
    setAnswers(prev => ({
      ...prev,
      [questionIndex]: option
    }));
  };

  const handleSubmit = () => {
    fetch(`${API_BASE}/submit`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ answers })
    })
      .then(res => res.json())
      .then(data => {
        setScore(data.score);
        setSubmitted(true);
      })
      .catch(() => setError('Failed to submit answers'));
  };

  return (
    <div style={{ textAlign: 'center', marginTop: '50px' }}>
      <h1>Quiz App </h1>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {quiz ? (
        <>
          <h2>{quiz.title}</h2>
          {quiz.questions.map((q, index) => (
            <div key={index} style={{ marginBottom: '30px' }}>
              <p><strong>Q{index + 1}:</strong> {q.questionText}</p>
              <ul style={{ listStyle: 'none', padding: 0 }}>
                {q.options.map((opt, i) => (
                  <li key={i} style={{ margin: '8px 0' }}>
                    <button
                      onClick={() => handleSelect(index, opt)}
                      disabled={submitted}
                      style={{
                        padding: '8px 16px',
                        borderRadius: '6px',
                        border: answers[index] === opt ? '2px solid #007bff' : '1px solid #ccc',
                        backgroundColor: answers[index] === opt ? '#e6f0ff' : '#fff',
                        cursor: submitted ? 'not-allowed' : 'pointer'
                      }}
                    >
                      {opt}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          ))}
          {!submitted ? (
            <button
              onClick={handleSubmit}
              style={{
                padding: '10px 20px',
                fontSize: '16px',
                borderRadius: '8px',
                backgroundColor: '#28a745',
                color: '#fff',
                border: 'none',
                cursor: 'pointer',
                marginTop: '20px'
              }}
            >
              Submit Answers
            </button>
          ) : (
            <p style={{ fontSize: '18px', color: '#007bff' }}>
              Submission successful! Your score: <strong>{score}</strong>
            </p>
          )}
        </>
      ) : (
        <p>Loading quiz...</p>
      )}
    </div>
  );
}

export default App;