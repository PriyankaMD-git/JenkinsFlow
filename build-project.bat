@echo off
setlocal enabledelayedexpansion

echo 🔧 Starting JenkinsFlow build...

REM Optional cleanup: remove old containers
docker rm -f frontend-container backend-container 2>NUL

REM Build frontend Docker image
echo 🚀 Building frontend...
cd frontend
docker build -t quiz-frontend .
cd ..

REM Build backend Docker image
echo 🚀 Building backend...
cd backend
docker build -t quiz-backend .
cd ..

REM Run frontend container
echo 🧪 Running frontend container...
docker run -d -p 3000:3000 --name frontend-container quiz-frontend

REM Run backend container
echo 🧪 Running backend container...
docker run -d -p 5000:5000 --name backend-container quiz-backend

echo ✅ Build and deployment complete!
endlocal