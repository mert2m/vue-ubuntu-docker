# VueJS Documentation Deployment Project

This project provides a containerized development environment for customizing and deploying the VueJS Documentation website.

## Prerequisites

- Docker
- Docker Compose
- Git

## Quick Start

1. Clone this repository
2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

## Project Structure

- `docker/` - Docker configuration files
  - `app/` - VueJS application container
  - `nginx/` - Nginx web server container
- `scripts/` - Automation scripts
- `src/` - Source code (VueJS documentation)

## Technical Stack

- Node.js 18+
- Docker
- Nginx
- Ubuntu 22.04 LTS base image

## Development

The development environment is fully containerized and automated. After running the setup script, you'll have:
- VueJS documentation running in a Node.js container
- Nginx serving the application
- Hot-reloading enabled for development 