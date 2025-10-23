@echo off
echo 🔧 Starting JenkinsFlow build...

:: === VERSION CONTROL ===
set VERSION=latest  :: ✅ Matches Docker Hub tag

:: === Docker Hub Credentials ===
set DOCKER_USER=priyankadhavale
set FRONTEND_IMAGE=jenkinsflow-frontend
set BACKEND_IMAGE=jenkinsflow-backend

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

:: Remove old containers if they exist
docker rm -f jenkinsflow-frontend-app 2>nul
docker rm -f jenkinsflow-backend-app 2>nul

:: Run updated containers
docker run -d -p 3000:80 --name jenkinsflow-frontend-app %DOCKER_USER%/%FRONTEND_IMAGE%:%VERSION%
docker run -d -p 5001:5000 --name jenkinsflow-backend-app %DOCKER_USER%/%BACKEND_IMAGE%:%VERSION%

echo ✅ Build and deployment complete!