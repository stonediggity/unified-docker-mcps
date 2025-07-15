#!/bin/bash

# Development Deployment Script
# This script deploys the MCP servers in development mode with all features enabled

set -e

echo "🚀 Deploying MCP Docker Servers - Development Environment"
echo "========================================================"

# Check if .env.dev exists, if not copy from example
if [ ! -f .env.dev ]; then
    echo "📋 Creating .env.dev from template..."
    cp .env.example .env.dev
    echo "⚠️  Please edit .env.dev with your actual API keys and database URLs"
    echo "   Then run this script again."
    exit 1
fi

# Build base image first
echo "🏗️  Building base image..."
./scripts/build-base.sh

# Create log directories
echo "📁 Creating log directories..."
mkdir -p logs/context7 logs/puppeteer logs/postgres logs/sequentialthinking

# Deploy with development configuration
echo "🐳 Starting services in development mode..."
docker-compose \
    --env-file .env.dev \
    -f docker-compose.yml \
    -f docker-compose.dev.yml \
    up -d

echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "✅ Development deployment complete!"
echo ""
echo "🌐 Available services:"
echo "   • Prometheus: http://localhost:9090"
echo "   • Grafana: http://localhost:3000 (admin/admin)"
echo "   • cAdvisor: http://localhost:8080"
echo "   • MCP Gateway: http://localhost:8812"
echo ""
echo "📝 Logs are available in the ./logs/ directory"
echo "🔧 Configuration: .env.dev"
echo ""
echo "To stop services: docker-compose -f docker-compose.yml -f docker-compose.dev.yml down"