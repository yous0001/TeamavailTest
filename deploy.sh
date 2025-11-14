#!/bin/bash

set -e

echo "========================================="
echo "Deploying Team Availability Application"
echo "========================================="

if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Error: docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

COMPOSE_CMD="docker compose"
if ! docker compose version &> /dev/null; then
    COMPOSE_CMD="docker-compose"
fi

echo ""
echo "Step 1: Stopping any existing containers..."
$COMPOSE_CMD down

echo ""
echo "Step 2: Building Docker images..."
$COMPOSE_CMD build --no-cache

echo ""
echo "Step 3: Starting containers..."
$COMPOSE_CMD up -d

echo ""
echo "Step 4: Waiting for services to be healthy..."
sleep 10

if docker ps | grep -q "teamavail-backend" && docker ps | grep -q "teamavail-frontend" && docker ps | grep -q "teamavail-mongodb"; then
    echo ""
    echo "========================================="
    echo "✅ Deployment successful!"
    echo "========================================="
    echo ""
    echo "Frontend is running at: http://localhost:5000"
    echo "Backend API is running at: http://localhost:3000"
    echo "MongoDB is running on: localhost:27017"
    echo ""
    echo "To view logs, run: $COMPOSE_CMD logs -f"
    echo "To stop the application, run: ./stop.sh"
    echo ""
else
    echo ""
    echo "❌ Deployment failed. Check logs with: $COMPOSE_CMD logs"
    exit 1
fi

