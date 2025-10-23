@echo off
echo 🔧 Starting JenkinsFlow build...

:: === VERSION CONTROL ===
set VERSION=v1.0.0

:: === Docker Hub Credentials ===
set DOCKER_USER=priyankadhavale
set FRONTEND_IMAGE=quiz-frontend
set BACKEND_IMAGE=quiz-backend

:: === Build frontend ===
echo 🚀 Building frontend...
cd frontend
docker build -t %FRONTEND_IMAGE% .
docker tag %FRONTEND_IMAGE% %DOCKER_USER%/%FRONTEND_IMAGE%:%VERSION%
docker push %DOCKER_USER%/%FRONTEND_IMAGE%:%VERSION%
cd ..

:: === Build backend ===
echo 🚀 Building backend...
cd backend
docker build -t %BACKEND_IMAGE% .
docker tag %BACKEND_IMAGE% %DOCKER_USER%/%BACKEND_IMAGE%:%VERSION%
docker push %DOCKER_USER%/%BACKEND_IMAGE%:%VERSION%
cd ..

:: === Run containers ===
echo 🧪 Running containers...
docker run -d -p 3000:3000 --name frontend-container %DOCKER_USER%/%FRONTEND_IMAGE%:%VERSION%
docker run -d -p 5000:5000 --name backend-container %DOCKER_USER%/%BACKEND_IMAGE%:%VERSION%

echo ✅ Build and deployment complete!