#!/bin/bash

# Exit on any error
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check system requirements
check_requirements() {
    log "Checking system requirements..."
    
    # Check OS
    if [[ "$(uname)" != "Linux" && "$(uname)" != "Darwin" ]]; then
        log "Error: This script is designed to run on Linux or macOS systems"
        exit 1
    }

    # Check Docker
    if ! command -v docker &> /dev/null; then
        log "Error: Docker is not installed. Please install Docker first."
        log "Visit https://docs.docker.com/get-docker/ for installation instructions."
        exit 1
    fi

    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        log "Error: Docker Compose is not installed. Please install Docker Compose first."
        log "Visit https://docs.docker.com/compose/install/ for installation instructions."
        exit 1
    fi

    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        log "Error: Docker daemon is not running. Please start Docker service."
        exit 1
    }

    log "All system requirements met ✓"
}

# Function to clean up on error
cleanup() {
    log "Error occurred. Cleaning up..."
    docker-compose down --remove-orphans &> /dev/null || true
    exit 1
}

# Set up error handling
trap cleanup ERR

# Main setup process
log "Starting development environment setup..."

# Check requirements
check_requirements

# Create necessary directories
log "Creating project directories..."
mkdir -p src

# Stop any existing containers
log "Stopping any existing containers..."
docker-compose down --remove-orphans &> /dev/null || true

# Pull latest images
log "Pulling latest images..."
docker-compose pull &> /dev/null || true

# Build and start containers
log "Building and starting containers..."
docker-compose up --build -d

# Verify containers are running
log "Verifying containers..."
if ! docker-compose ps | grep -q "Up"; then
    log "Error: Containers failed to start properly"
    cleanup
fi

log "Setup completed successfully! ✓"
log "You can access:"
log "- VueJS documentation at http://localhost"
log "- Development server at http://localhost:4000"
log "- Logs can be viewed with: docker-compose logs -f" 