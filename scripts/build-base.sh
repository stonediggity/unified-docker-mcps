#!/bin/bash

# Build Base Image Script
# This script builds the base MCP image and then all dependent services

set -e

echo "🏗️  Building MCP base image..."
docker-compose --profile build-base build mcp-base

echo "✅ Base image built successfully"
echo "🏗️  Building dependent services..."

# Build all services that depend on the base image
docker-compose build context7 puppeteer sequentialthinking

echo "✅ All services built successfully"
echo ""
echo "To start the services, run:"
echo "  docker-compose up -d"
echo ""
echo "To start with gateway, run:"
echo "  docker-compose --profile gateway up -d"