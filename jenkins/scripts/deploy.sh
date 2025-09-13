#!/bin/bash
docker pull yourhub/quiz-frontend:latest
docker pull yourhub/quiz-backend:latest

docker run -d -p 3000:3000 yourhub/quiz-frontend:latest
docker run -d -p 5000:5000 yourhub/quiz-backend:latest