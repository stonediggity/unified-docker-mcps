#!/bin/bash

echo "Setting up MCP Docker environment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

# Create .env file from example if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "Please edit .env file and add your API keys"
fi

# Build all Docker images
echo "Building Docker images..."
docker-compose build

# Start all services
echo "Starting MCP servers..."
docker-compose up -d

# Check status
echo "Checking container status..."
docker-compose ps

echo "Setup complete! MCP servers are running in Docker containers."
echo ""
echo "To use with Claude Desktop:"
echo "1. Copy the configuration from configs/claude_desktop_config.json"
echo "2. Add it to your Claude Desktop MCP configuration"
echo "3. Restart Claude Desktop"
echo ""
echo "To view logs: docker-compose logs -f [service-name]"
echo "To stop all services: docker-compose down"