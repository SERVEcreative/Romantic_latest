# Romantic App Development Startup Script
# This script starts both frontend and backend development servers

Write-Host "🚀 Starting Romantic App Development Environment..." -ForegroundColor Green

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check if Node.js is installed
if (-not (Test-Command "node")) {
    Write-Host "❌ Node.js is not installed. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check if Flutter is installed
if (-not (Test-Command "flutter")) {
    Write-Host "❌ Flutter is not installed. Please install Flutter first." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Prerequisites check passed!" -ForegroundColor Green

# Start Backend Server
Write-Host "🔧 Starting Backend Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; npm install; npm start" -WindowStyle Normal

# Wait a moment for backend to start
Start-Sleep -Seconds 3

# Start Frontend App
Write-Host "📱 Starting Frontend App..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; flutter pub get; flutter run" -WindowStyle Normal

Write-Host "🎉 Development environment started!" -ForegroundColor Green
Write-Host "📋 Backend API: http://localhost:3000" -ForegroundColor Cyan
Write-Host "📱 Frontend: Flutter app running on device/emulator" -ForegroundColor Cyan
Write-Host "🔗 Health Check: http://localhost:3000/health" -ForegroundColor Cyan

Write-Host "`n💡 Tips:" -ForegroundColor Magenta
Write-Host "   - Backend logs will appear in the first terminal" -ForegroundColor White
Write-Host "   - Frontend logs will appear in the second terminal" -ForegroundColor White
Write-Host "   - Press Ctrl+C in each terminal to stop the servers" -ForegroundColor White
