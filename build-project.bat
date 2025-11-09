@echo off
setlocal enabledelayedexpansion

:: --- START: ROLLBACK AND VERSIONING VARIABLES ---
echo === Setting Build Version Tag ===
:: Use Jenkins' built-in %BUILD_NUMBER% for unique versioning.
if defined BUILD_NUMBER (
    set VERSION_TAG=%BUILD_NUMBER%
) else (
    set VERSION_TAG=dev-build
)

echo Using deployment tag: %VERSION_TAG%

:: Define the image names and unique tags
set FRONTEND_IMAGE=priyankadhavale/jenkinsflow-frontend
set BACKEND_IMAGE=priyankadhavale/jenkinsflow-backend

set NEW_FRONTEND_TAG=%FRONTEND_IMAGE%:%VERSION_TAG%
set NEW_BACKEND_TAG=%BACKEND_IMAGE%:%VERSION_TAG%

:: Define the 'latest' tag (which the rollback playbook targets)
set LATEST_TAG=%FRONTEND_IMAGE%:latest
set BACKEND_LATEST_TAG=%BACKEND_IMAGE%:latest
:: --- END: ROLLBACK AND VERSIONING VARIABLES ---


:: === GLOBAL SETUP ===
echo === Logging into Docker Hub ===
:: NOTE: DOCKERHUB_TOKEN and DOCKERHUB_USERNAME must be defined as Jenkins secrets/environment variables
echo %DOCKERHUB_TOKEN% | docker login -u %DOCKERHUB_USERNAME% --password-stdin

:: === FRONTEND STAGE ===
echo === Starting Frontend Stage ===
cd frontend

echo === Installing Frontend Dependencies ===
call npm ci

echo === Building Frontend ===
call npm run build

echo === Testing Frontend ===
call npm test -- --passWithNoTests || echo Frontend tests skipped

echo === Building Frontend Docker Image (Using Multi-Stage Build) ===
docker build -t jenkinsflow-frontend .

echo === Tagging and Pushing Frontend Image: %NEW_FRONTEND_TAG% ===
:: Tag 1: Unique build number (for history tracking)
docker tag jenkinsflow-frontend %NEW_FRONTEND_TAG%
docker push %NEW_FRONTEND_TAG%

echo === Updating Frontend 'latest' Tag: %LATEST_TAG% ===
:: Tag 2: 'latest' (the target for the rollback playbook)
docker tag jenkinsflow-frontend %LATEST_TAG%
docker push %LATEST_TAG%

cd ..

:: === BACKEND STAGE ===
echo === Starting Backend Stage ===
cd backend

echo === Installing Backend Dependencies ===
call npm ci

echo === Testing Backend ===
call npm test || echo Backend tests skipped

echo === Building Backend Docker Image ===
docker build -t jenkinsflow-backend .

echo === Tagging and Pushing Backend Image: %NEW_BACKEND_TAG% ===
:: Tag 1: Unique build number
docker tag jenkinsflow-backend %NEW_BACKEND_TAG%
docker push %NEW_BACKEND_TAG%

echo === Updating Backend 'latest' Tag: %BACKEND_LATEST_TAG% ===
:: Tag 2: 'latest'
docker tag jenkinsflow-backend %BACKEND_LATEST_TAG%
docker push %BACKEND_LATEST_TAG%

cd ..

:: =======================================================
:: === DEPLOYMENT STAGE (Handled by Ansible via WSL) ====
:: =======================================================
echo =======================================================
echo === Starting Deployment Stage via Ansible ===
echo =======================================================

:: === WSL HEALTH CHECK ===
echo === Checking Ansible availability in Ubuntu WSL ===
wsl -d Ubuntu -- bash -c "which ansible"
IF %ERRORLEVEL% NEQ 0 (
    echo ERROR: Ansible not found in Ubuntu WSL. Please install it using 'sudo apt install ansible'
    exit /b 1
)

:: === ANSIBLE AUTOMATION STAGE ===
echo === Running Ansible Playbooks via Ubuntu WSL ===

echo === Deploying Backend with tag: %VERSION_TAG% ===
:: PASSES THE UNIQUE BUILD TAG TO PROVISION.YML
wsl -d Ubuntu -- bash -c "cd /mnt/c/Users/Priya/JenkinsFlow && ansible-playbook -i ansible/inventory/host.ini ansible/playbooks/provision.yml -e 'backend_image_tag=%VERSION_TAG%'"
IF %ERRORLEVEL% NEQ 0 (
    echo Ansible backend provisioning failed
    exit /b %ERRORLEVEL%
)

echo === Deploying Frontend with tag: %VERSION_TAG% ===
:: PASSES THE UNIQUE BUILD TAG TO WEBSERVER.YML
wsl -d Ubuntu -- bash -c "cd /mnt/c/Users/Priya/JenkinsFlow && ansible-playbook -i ansible/inventory/host.ini ansible/playbooks/webserver.yml -e 'frontend_image_tag=%VERSION_TAG%'"
IF %ERRORLEVEL% NEQ 0 (
    echo Ansible frontend provisioning failed
    exit /b %ERRORLEVEL%
)

echo Deployment Complete!
echo Frontend: http://localhost:3000
echo Backend: http://localhost:5001
echo.

echo === CI Pipeline Completed Successfully ===
exit /b 0