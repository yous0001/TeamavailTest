#!/bin/bash

set -e

echo "========================================="
echo "Stopping Team Availability Application"
echo "========================================="

if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Error: Docker is not running."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Error: docker-compose is not installed."
    exit 1
fi

COMPOSE_CMD="docker compose"
if ! docker compose version &> /dev/null; then
    COMPOSE_CMD="docker-compose"
fi

echo ""
echo "Stopping containers..."
$COMPOSE_CMD down

echo ""
echo "Checking for stopped containers..."
if docker ps -a | grep -q "teamavail"; then
    echo "Removing stopped containers..."
    docker ps -a | grep "teamavail" | awk '{print $1}' | xargs -r docker rm -f 2>/dev/null || true
fi

echo ""
echo "========================================="
echo "✅ Application stopped successfully!"
echo "========================================="
echo ""
echo "Note: MongoDB data volume is preserved."
echo "To remove all data, run: $COMPOSE_CMD down -v"
echo ""

