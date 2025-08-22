@echo off
echo 🚀 Starting Romantic App Development Environment...

REM Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js is not installed. Please install Node.js first.
    pause
    exit /b 1
)

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    pause
    exit /b 1
)

echo ✅ Prerequisites check passed!

REM Start Backend Server
echo 🔧 Starting Backend Server...
start "Backend Server" cmd /k "cd backend && npm install && npm start"

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Start Frontend App
echo 📱 Starting Frontend App...
start "Frontend App" cmd /k "cd frontend && flutter pub get && flutter run"

echo 🎉 Development environment started!
echo 📋 Backend API: http://localhost:3000
echo 📱 Frontend: Flutter app running on device/emulator
echo 🔗 Health Check: http://localhost:3000/health

echo.
echo 💡 Tips:
echo    - Backend logs will appear in the first terminal
echo    - Frontend logs will appear in the second terminal
echo    - Close the terminal windows to stop the servers

pause
