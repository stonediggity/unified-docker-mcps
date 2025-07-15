# Development Guide

This document provides development setup instructions and common commands for working with the MCP Docker Servers project.

## Prerequisites

- Docker and Docker Compose installed
- Basic familiarity with MCP (Model Context Protocol)
- API keys for required services (OpenRouter, PostgreSQL database)
- Claude Code installed for project-specific MCP usage

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
# Start core MCP services (recommended)
docker-compose up -d

# Start all services including optional gateway
docker-compose --profile gateway up -d

# Start specific service
docker-compose up -d zen

# Stop all services
docker-compose down

# Stop specific service
docker-compose stop context7

# Restart service
docker-compose restart postgres
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

### Claude Code Integration (Project-Specific)
- Create `.mcp.json` in your project root directory
- Configure MCP servers specific to that project
- Example configuration provided in README.md

### Individual Dockerfiles
- `dockerfiles/Dockerfile.context7` - Context7 MCP server
- `dockerfiles/Dockerfile.puppeteer` - Puppeteer automation
- `dockerfiles/Dockerfile.postgres` - PostgreSQL MCP server with database analysis
- `dockerfiles/Dockerfile.sequentialthinking` - Sequential Thinking MCP server
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

### PostgreSQL MCP Debugging
```bash
# Check PostgreSQL MCP server status
docker-compose logs postgres

# Test database connectivity
docker exec -it mcp-postgres node -e "console.log('PostgreSQL MCP server running')"

# Verify environment variables
docker exec -it mcp-postgres env | grep DATABASE_URL_STRING

# Common PostgreSQL issues:
# - Invalid DATABASE_URL_STRING format
# - Network connectivity to database
# - Database authentication failures
# - Missing database permissions
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
- `DATABASE_URL_STRING` - For PostgreSQL MCP server (format: postgresql://username:password@host:port/database)

## Testing

### Quick Health Check
```bash
# Test all services are running
docker-compose ps

# Test specific service logs
docker-compose logs --tail=10 postgres
```

### PostgreSQL MCP Testing
```bash
# Test PostgreSQL MCP server connectivity
docker-compose logs postgres

# Verify database connection
docker exec -it mcp-postgres /bin/bash
# Inside container: test basic MCP functionality

# Test database schema analysis capabilities
# Use Claude Desktop to run commands like:
# "Show me the database schemas"
# "Analyze the database health"
# "List all tables in public schema"
```

### Integration Testing
```bash
# Test Claude Desktop connection
# Use configs/claude_desktop_config.json
# Restart Claude Desktop and test MCP commands

# PostgreSQL MCP specific tests:
# - Database schema exploration
# - Query performance analysis  
# - Database health monitoring
# - SQL query execution
```

## Deployment

For production deployment:
1. Secure your API keys
2. Use proper logging configuration
3. Set up monitoring and alerting
4. Consider using Docker Swarm or Kubernetes for scaling

## MCP Usage in Projects

### Using MCP Servers with Claude Code

1. **Ensure Docker containers are running**
   ```bash
   docker-compose ps  # Check status
   docker-compose up -d  # Start if needed
   ```

2. **Create `.mcp.json` in your project root**
   ```json
   {
     "mcpServers": {
       "postgres": {
         "command": "docker",
         "args": [
           "exec",
           "-i",
           "mcp-postgres",
           "postgres-mcp",
           "--access-mode=unrestricted",
           "--transport=stdio",
           "postgresql://localhost:5432/myproject"
         ]
       }
     }
   }
   ```

3. **Available MCP Commands**
   - **Context7**: Documentation search and analysis
   - **Puppeteer**: Web scraping and browser automation
   - **PostgreSQL**: Database queries, schema analysis, performance optimization
   - **Sequential Thinking**: Complex problem-solving with step-by-step reasoning

### Example Use Cases

**Database Analysis with PostgreSQL MCP:**
```
"Show me all tables in the public schema"
"Analyze the performance of my queries"
"Check for missing indexes"
"Monitor database health"
```

**Web Automation with Puppeteer:**
```
"Take a screenshot of example.com"
"Fill out the login form on the page"
"Extract all links from the current page"
```

**Documentation with Context7:**
```
"Search Next.js docs for routing"
"Find React hooks documentation"
"Look up PostgreSQL JSON functions"
```

## Getting Help

- Check container logs first: `docker-compose logs [service-name]`
- Verify environment variables are set correctly
- Ensure Docker and docker-compose are up to date
- For MCP-specific issues, check `.mcp.json` configuration
- Open issues in this repository for bugs or feature requests