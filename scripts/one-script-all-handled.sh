#!/bin/bash

# Exit on any error
set -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to install Docker and Docker Compose
install_docker() {
    log "Installing Docker and Docker Compose..."

    # Update package list
    sudo apt update -y

    # Install required dependencies
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker GPG key and repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker

    # Add current user to the Docker group (optional, avoids needing sudo)
    sudo usermod -aG docker $USER

    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    log "Docker and Docker Compose installed successfully! ✓"
}

# Function to check system requirements
check_requirements() {
    log "Checking system requirements..."
    
    # Check OS
    if [[ "$(uname)" != "Linux" && "$(uname)" != "Darwin" ]]; then
        log "Error: This script is designed to run on Linux or macOS systems"
        exit 1
    fi

    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        log "Docker is not installed. Installing now..."
        install_docker
    fi

    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        log "Docker Compose is not installed. Installing now..."
        install_docker
    fi

    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        log "Docker daemon is not running. Starting Docker..."
        sudo systemctl start docker
    fi

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

# Check and install requirements
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
