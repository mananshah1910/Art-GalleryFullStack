#!/bin/bash

# Trap CTRL+C to kill child processes when you stop the script
trap 'echo "Stopping all services..."; kill 0; exit 1' SIGINT SIGTERM

echo "=========================================="
echo "🖼️  Starting Art Gallery Ecosystem..."
echo "=========================================="

echo "[1/3] Starting MySQL..."
brew services start mysql
echo "MySQL started! ✅"
echo ""

# Get the script directory to use absolute paths
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

echo "[2/3] Starting Spring Boot Backend (Port 8080)..."
cd "$ROOT_DIR/Art-Gallery-Backend"
mvn clean spring-boot:run &
BACKEND_PID=$!

# Give backend a few seconds to start compiling before frontend output streams in
sleep 5

echo "[3/3] Starting React Frontend (Port 5173)..."
cd "$ROOT_DIR/Art-Gallery"
npm run dev &
FRONTEND_PID=$!

echo ""
echo "=========================================="
echo "🚀 Everything is booting up!"
echo "👉 Backend: http://localhost:8080"
echo "👉 Swagger: http://localhost:8080/swagger-ui.html"
echo "👉 Frontend: http://localhost:5173"
echo "⚠️  Keep this terminal open. Press CTRL+C to stop all."
echo "=========================================="

# Wait for processes
wait $BACKEND_PID
wait $FRONTEND_PID
