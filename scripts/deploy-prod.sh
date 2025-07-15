#!/bin/bash

# Production Deployment Script
# This script deploys the MCP servers in production mode with optimized settings

set -e

echo "🚀 Deploying MCP Docker Servers - Production Environment"
echo "========================================================"

# Check if .env.prod exists
if [ ! -f .env.prod ]; then
    echo "❌ Error: .env.prod file not found!"
    echo "   Please create .env.prod with your production configuration"
    echo "   You can copy from .env.example and modify for production"
    exit 1
fi

# Validate required environment variables
echo "🔍 Validating environment configuration..."
source .env.prod

if [ -z "$OPENROUTER_API_KEY" ]; then
    echo "❌ Error: OPENROUTER_API_KEY not set in .env.prod"
    exit 1
fi

if [ -z "$DATABASE_URL_STRING" ]; then
    echo "❌ Error: DATABASE_URL_STRING not set in .env.prod"
    exit 1
fi

# Build base image first
echo "🏗️  Building base image for production..."
./scripts/build-base.sh

# Pull latest images
echo "📥 Pulling latest base images..."
docker-compose \
    --env-file .env.prod \
    -f docker-compose.yml \
    -f docker-compose.prod.yml \
    pull --ignore-pull-failures

# Build services
echo "🔨 Building services for production..."
docker-compose \
    --env-file .env.prod \
    -f docker-compose.yml \
    -f docker-compose.prod.yml \
    build --no-cache

# Deploy with production configuration
echo "🐳 Starting services in production mode..."
docker-compose \
    --env-file .env.prod \
    -f docker-compose.yml \
    -f docker-compose.prod.yml \
    --profile monitoring \
    up -d

echo "⏳ Waiting for services to start..."
sleep 15

# Check service health
echo "🔍 Checking service health..."
for service in context7 puppeteer postgres sequentialthinking; do
    if docker-compose ps $service | grep -q "Up"; then
        echo "✅ $service: healthy"
    else
        echo "❌ $service: unhealthy"
    fi
done

# Show service status
echo ""
echo "📊 Service status:"
docker-compose \
    --env-file .env.prod \
    -f docker-compose.yml \
    -f docker-compose.prod.yml \
    ps

echo ""
echo "✅ Production deployment complete!"
echo ""
echo "🌐 Available services:"
echo "   • Prometheus: http://localhost:${PROMETHEUS_PORT:-9090}"
if [ "$GRAFANA_ENABLED" = "true" ]; then
    echo "   • Grafana: http://localhost:3000"
fi
echo "   • MCP Gateway: http://localhost:${GATEWAY_PORT:-8811}"
echo ""
echo "📋 Production checklist:"
echo "   □ Configure firewall rules"
echo "   □ Set up SSL certificates"
echo "   □ Configure log rotation"
echo "   □ Set up monitoring alerts"
echo "   □ Configure backups"
echo ""
echo "🔧 Configuration: .env.prod"
echo ""
echo "To stop services: docker-compose -f docker-compose.yml -f docker-compose.prod.yml down"