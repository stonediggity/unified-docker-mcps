# MCP Docker Servers

A complete Docker setup for running multiple MCP (Model Context Protocol) servers in isolated containers. This repository provides secure, production-ready containerized versions of popular MCP servers.

## Features

- 🐳 **Containerized MCP Servers**: Context7, Puppeteer, Zen, and PostgreSQL MCP servers
- 🔒 **Security First**: Containers run as non-root users with security hardening
- 🚀 **Easy Setup**: One-command deployment with Docker Compose
- 🔧 **Flexible Configuration**: Support for both composed and standalone deployment
- 📝 **Complete Documentation**: Comprehensive setup and troubleshooting guides

## Project Structure

```
├── docker-compose.yml           # Main orchestration file
├── dockerfiles/                 # Individual container definitions
│   ├── Dockerfile.context7
│   ├── Dockerfile.puppeteer
│   ├── Dockerfile.zen
│   ├── Dockerfile.postgres
│   ├── Dockerfile.base-node
│   └── Dockerfile.gateway
├── configs/                     # Claude Desktop configurations
│   ├── claude_desktop_config.json
│   ├── claude_desktop_config_standalone.json
│   └── mcp-gateway-config.json
├── scripts/
│   └── setup.sh               # Automated setup script
├── downloads/                  # Puppeteer download directory
├── .env.example               # Environment variables template
└── README.md                  # This file
```

## Quick Start

1. **Clone and Setup Environment**
   ```bash
   # Copy environment file and add your API keys
   cp .env.example .env
   nano .env  # Edit with your actual API keys
   
   # Run automated setup
   ./scripts/setup.sh
   ```

2. **Configure Claude Desktop**
   - Copy the configuration from `configs/claude_desktop_config.json`
   - Add it to your Claude Desktop MCP configuration file
   - Restart Claude Desktop

## Individual Services

### Context7 MCP Server
Provides AI-powered context analysis and understanding for documentation and code.

### Puppeteer MCP Server
Web scraping and browser automation capabilities for data extraction and testing.

### Zen MCP Server
Advanced AI reasoning and analysis tools with support for multiple AI models.

### PostgreSQL MCP Server
Comprehensive PostgreSQL database management and analysis platform offering:

- **Schema Analysis**: Explore database schemas, tables, views, and relationships
- **Query Optimization**: Analyze query execution plans and performance bottlenecks  
- **Database Health Monitoring**: Check for bloated indexes, vacuum health, and connection utilization
- **Performance Insights**: Get recommendations for indexes and query improvements
- **Workload Analysis**: Identify slow queries and resource-intensive operations
- **Advanced SQL Execution**: Run complex queries with detailed result analysis

## Usage Instructions

### Start Services
```bash
# Start core MCP services (recommended)
docker-compose up -d

# Start all services including gateway
docker-compose --profile gateway up -d

# Start specific service
docker-compose up -d context7
```

### Monitor Services
```bash
# View logs
docker-compose logs -f context7

# Check container status
docker-compose ps

# Enter container for debugging
docker exec -it mcp-context7 /bin/bash
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop specific service
docker-compose stop context7
```

## Configuration Options

### Using Docker Compose (Recommended)
Services run continuously and can be managed with docker-compose commands.

### Using Standalone Docker Run
Alternative configuration in `configs/claude_desktop_config_standalone.json` runs containers on-demand.

## Security Features

1. **Container Isolation**: Each MCP server runs in its own container
2. **Read-only Filesystems**: Where possible, containers use read-only root filesystems
3. **Non-root Users**: All containers run as non-root users
4. **Network Isolation**: Services communicate through a dedicated Docker network
5. **No New Privileges**: Security option prevents privilege escalation
6. **Environment Variables**: Sensitive data is passed via environment variables

## Environment Variables

Required environment variables in `.env`:

- `OPENROUTER_API_KEY`: API key for Zen MCP server ([Get from OpenRouter](https://openrouter.ai/))
- `DATABASE_URL_STRING`: PostgreSQL connection string for PostgreSQL MCP server (format: postgresql://username:password@host:port/database)

## Troubleshooting

### Common Issues

1. **Container exits immediately**
   ```bash
   docker logs mcp-[service-name]
   ```

2. **Permission issues**
   Ensure the user in the container has necessary access rights.

3. **Network connectivity**
   Verify containers are on the same Docker network:
   ```bash
   docker network ls
   docker network inspect 2-unified-mcps_mcp-network
   ```

4. **STDIO communication issues**
   Ensure `stdin_open: true` and `tty: true` are set in docker-compose.yml

### Service-Specific Issues

**Puppeteer**: If Chrome fails to start, check that the container has sufficient capabilities:
```bash
docker run --cap-add=SYS_ADMIN --security-opt seccomp=unconfined mcp-puppeteer:latest
```

**Zen**: Ensure OPENROUTER_API_KEY is properly set in your .env file.

**PostgreSQL**: Verify DATABASE_URL_STRING is correctly configured with a valid PostgreSQL connection string. Test database connectivity with:
```bash
docker-compose logs postgres
```

Common PostgreSQL MCP server capabilities:
- Database schema exploration and table analysis
- Query performance analysis and optimization recommendations  
- Database health checks and maintenance insights
- Advanced SQL query execution with detailed results

## Adding New MCP Servers

To add additional MCP servers:

1. Create a new Dockerfile in `dockerfiles/`
2. Add the service to `docker-compose.yml`
3. Update Claude Desktop configuration
4. Rebuild and restart services

Example for adding a new server:
```yaml
new-server:
  build:
    context: .
    dockerfile: dockerfiles/Dockerfile.new-server
  container_name: mcp-new-server
  stdin_open: true
  tty: true
  networks:
    - mcp-network
  restart: unless-stopped
```

## Development

See [CLAUDE.md](./CLAUDE.md) for development setup instructions and common commands.

## License

This project is open source. Individual MCP servers may have their own licenses.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

If you encounter issues:

1. Check container logs: `docker-compose logs [service-name]`
2. Verify environment variables are set correctly
3. Ensure Docker and docker-compose are up to date
4. Check that required ports are not in use by other services
5. Open an issue in this repository with details

For additional help, consult the individual MCP server documentation.