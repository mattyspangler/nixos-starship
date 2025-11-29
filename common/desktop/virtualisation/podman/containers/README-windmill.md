# Windmill Containers

This directory contains the Windmill workflow engine container configuration for NixOS.

## Overview

Windmill is a self-hostable workflow engine that allows you to build, deploy, and run workflows. This configuration includes:

- **PostgreSQL database**: Windmill's backend database
- **Windmill server**: Main API server and web UI
- **Windmill workers**: Multiple worker instances for executing scripts
- **Caddy reverse proxy**: Load balancer and reverse proxy

## Container Configuration

The setup includes multiple containers that work together:

1. **windmill-postgres**: PostgreSQL 16 database
2. **windmill-server**: Windmill API server (ports 8000, 2525)
3. **windmill-worker1**: Standard worker for general tasks
4. **windmill-native-worker**: Native optimized worker
5. **windmill-caddy**: Reverse proxy (ports 80, 25)

## Access

- **Web UI**: http://localhost (via Caddy)
- **Direct API**: http://localhost:8000
- **Default credentials**: admin@windmill.dev / changeme

## Usage

The containers will automatically start when the system boots. You can manage them using Podman:

```bash
# View running containers
podman ps

# View logs
podman logs windmill-server

# Restart containers
podman restart windmill-server
```

## Configuration

Key environment variables can be modified in `windmill.nix`:

- `DATABASE_URL`: PostgreSQL connection string
- `POSTGRES_PASSWORD`: Database password (change for production!)
- `BASE_URL`: Base URL for the web interface

## Persistence

Data is persisted in the following directories:
- `/var/lib/windmill-postgres`: PostgreSQL data
- `/var/lib/windmill-dependency-cache`: Script dependencies
- `/var/lib/windmill-logs`: Worker logs
- `/var/lib/windmill-caddy`: Caddy data

## Security

For production deployments:
1. Change the default PostgreSQL password
2. Configure HTTPS/SSL certificates
3. Set up proper firewall rules
4. Consider using external managed database