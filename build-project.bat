@echo off
echo 🔧 Starting JenkinsFlow build...

REM Build frontend
echo 🚀 Building frontend...
cd frontend
docker build -t quiz-frontend .
cd ..

REM Build backend
echo 🚀 Building backend...
cd backend
docker build -t quiz-backend .
cd ..

REM Run containers
echo 🧪 Running containers...
docker run -d -p 3000:3000 --name frontend-container quiz-frontend
docker run -d -p 5000:5000 --name backend-container quiz-backend

echo ✅ Build and deployment complete!