import React, { useEffect, useState } from 'react';

const API_BASE = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';

function App() {
  const [quiz, setQuiz] = useState(null);
  const [answers, setAnswers] = useState({});
  const [error, setError] = useState('');

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

  return (
    <div style={{ textAlign: 'center', marginTop: '50px' }}>
      <h1>Quiz App 🚀</h1>
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
                      style={{
                        padding: '8px 16px',
                        borderRadius: '6px',
                        border: answers[index] === opt ? '2px solid #007bff' : '1px solid #ccc',
                        backgroundColor: answers[index] === opt ? '#e6f0ff' : '#fff',
                        cursor: 'pointer'
                      }}
                    >
                      {opt}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </>
      ) : (
        <p>Loading quiz...</p>
      )}
    </div>
  );
}

export default App;