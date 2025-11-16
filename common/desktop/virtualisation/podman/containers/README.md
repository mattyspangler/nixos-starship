# MCP Servers Configuration

This directory contains the MCP (Model Context Protocol) server configurations for desktop environments.

## Configured Servers

### 1. Context7 MCP Server
- **Container**: `context7-mcp`
- **Image**: `node:18-alpine` with npm package installation
- **Transport**: stdio
- **Purpose**: Vector database and semantic search capabilities
- **Configuration**: Add your Context7 API key as environment variable if needed

### 2. Playwright MCP Server  
- **Container**: `playwright-mcp`
- **Image**: `mcr.microsoft.com/playwright/mcp:latest`
- **Port**: `8931` (HTTP transport)
- **Purpose**: Browser automation and web scraping
- **Browser**: Headless Chromium (Docker limitation)

### 3. Crush (CLI Tool)
- **Location**: Installed via home-manager in `common/home-manager/core/ml/default.nix`
- **Purpose**: General-purpose AI assistant with LSP integration

## Usage

### For MCP Client Configuration

Add these to your MCP client configuration (e.g., Claude Desktop, Continue.dev, etc.):

```json
{
  "mcpServers": {
    "context7": {
      "command": "podman",
      "args": ["run", "-i", "--rm", "context7-mcp"],
      "transportType": "stdio"
    },
    "playwright": {
      "url": "http://localhost:8931/mcp"
    }
  }
}
```

### Starting/Stopping Containers

```bash
# Start containers
sudo podman start context7-mcp playwright-mcp

# Stop containers  
sudo podman stop context7-mcp playwright-mcp

# Check status
sudo podman ps
```

### Crush Configuration

Crush is configured via home-manager with:
- LSP servers for multiple languages
- Nano-GPT provider configuration
- Model settings in `~/.config/crush/crush.json`

## Notes

- Context7 requires an API key from https://context7.com/dashboard for higher rate limits
- Playwright only supports headless Chromium in containerized environments
- Crush runs as a native binary with full system access
- All containers are configured to auto-start with the system