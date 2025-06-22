# Development Guide

This document provides development setup instructions and common commands for working with the MCP Docker Servers project.

## Prerequisites

- Docker and Docker Compose installed
- Basic familiarity with MCP (Model Context Protocol)
- API keys for required services (OpenRouter, Supabase)

## Development Setup

### Initial Setup
```bash
# Copy environment template
cp .env.example .env

# Edit with your actual API keys
nano .env

# Run setup script
./scripts/setup.sh
```

### Manual Setup (Alternative)
```bash
# Build all images
docker-compose build

# Start services in background
docker-compose up -d

# Check status
docker-compose ps
```

## Common Commands

### Service Management
```bash
# Start all services
docker-compose up -d

# Start specific service
docker-compose up -d zen

# Stop all services
docker-compose down

# Stop specific service
docker-compose stop context7

# Restart service
docker-compose restart puppeteer
```

### Monitoring and Debugging
```bash
# View logs for all services
docker-compose logs -f

# View logs for specific service
docker-compose logs -f zen

# Check container status
docker-compose ps

# Enter container for debugging
docker exec -it mcp-zen /bin/bash

# View resource usage
docker stats
```

### Development Workflow
```bash
# Rebuild after changes
docker-compose build [service-name]

# Rebuild and restart
docker-compose up -d --build [service-name]

# Remove containers and volumes
docker-compose down -v

# Clean up everything
docker-compose down -v --rmi all
```

## Configuration Files

### Docker Compose Configuration
- `docker-compose.yml` - Main orchestration file
- Environment variables passed via `.env` file

### Claude Desktop Integration
- `configs/claude_desktop_config.json` - For Docker Compose setup
- `configs/claude_desktop_config_standalone.json` - For standalone containers

### Individual Dockerfiles
- `dockerfiles/Dockerfile.context7` - Context7 MCP server
- `dockerfiles/Dockerfile.puppeteer` - Puppeteer automation
- `dockerfiles/Dockerfile.zen` - Zen AI reasoning tools
- `dockerfiles/Dockerfile.supabase` - Supabase database operations
- `dockerfiles/Dockerfile.gateway` - MCP Gateway (optional)

## Adding New Services

1. **Create Dockerfile**
   ```bash
   # Create new Dockerfile
   touch dockerfiles/Dockerfile.newservice
   ```

2. **Add to docker-compose.yml**
   ```yaml
   newservice:
     build:
       context: .
       dockerfile: dockerfiles/Dockerfile.newservice
     container_name: mcp-newservice
     stdin_open: true
     tty: true
     networks:
       - mcp-network
     restart: unless-stopped
   ```

3. **Update Claude Desktop config**
   Add new service to `configs/claude_desktop_config.json`

4. **Test and deploy**
   ```bash
   docker-compose build newservice
   docker-compose up -d newservice
   ```

## Troubleshooting

### Container Issues
```bash
# Check container logs
docker logs mcp-[service-name]

# Inspect container
docker inspect mcp-[service-name]

# Check network connectivity
docker network inspect 2-unified-mcps_mcp-network
```

### Build Issues
```bash
# Clean build cache
docker builder prune

# Rebuild from scratch
docker-compose build --no-cache

# Remove all containers and rebuild
docker-compose down
docker-compose up -d --build
```

### Permission Issues
```bash
# Check file permissions
ls -la dockerfiles/

# Fix executable permissions
chmod +x scripts/setup.sh
```

## Security Considerations

- Keep `.env` file private (already in .gitignore)
- All containers run as non-root users
- Use read-only filesystems where possible
- Network isolation through Docker networks
- No new privileges security option enabled

## Performance Tips

- Use multi-stage builds in Dockerfiles
- Leverage Docker layer caching
- Monitor resource usage with `docker stats`
- Use specific service names in commands for faster execution

## Environment Variables

Required in `.env` file:
- `OPENROUTER_API_KEY` - For Zen MCP server
- `SUPABASE_ACCESS_TOKEN` - For Supabase MCP server

## Testing

### Quick Health Check
```bash
# Test all services are running
docker-compose ps

# Test specific service logs
docker-compose logs --tail=10 zen
```

### Integration Testing
```bash
# Test Claude Desktop connection
# Use configs/claude_desktop_config.json
# Restart Claude Desktop and test MCP commands
```

## Deployment

For production deployment:
1. Secure your API keys
2. Use proper logging configuration
3. Set up monitoring and alerting
4. Consider using Docker Swarm or Kubernetes for scaling

## Getting Help

- Check container logs first: `docker-compose logs [service-name]`
- Verify environment variables are set correctly
- Ensure Docker and docker-compose are up to date
- Open issues in this repository for bugs or feature requests