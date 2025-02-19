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
    fi

    # Check OpenSSL
    if ! command -v openssl &> /dev/null; then
        log "Error: OpenSSL is not installed. Please install OpenSSL first."
        exit 1
    fi

    log "All system requirements met ✓"
}

# Function to generate SSL certificates
generate_ssl_certificates() {
    log "Generating SSL certificates..."
    
    # SSL certificate directory
    SSL_DIR="./docker/nginx/ssl"
    
    
    mkdir -p $SSL_DIR
    
    
    openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout $SSL_DIR/nginx-selfsigned.key \
        -out $SSL_DIR/nginx-selfsigned.crt \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    
    
    openssl dhparam -out $SSL_DIR/dhparam.pem 2048
    
    log "SSL certificates generated successfully ✓"
}


cleanup() {
    log "Error occurred. Cleaning up..."
    docker-compose down --remove-orphans &> /dev/null || true
    exit 1
}


trap cleanup ERR


log "Starting development environment setup..."


check_requirements

log "Creating project directories..."
mkdir -p src

generate_ssl_certificates

log "Stopping any existing containers..."
docker-compose down --remove-orphans &> /dev/null || true

log "Pulling latest images..."
docker-compose pull &> /dev/null || true

log "Building and starting containers..."
docker-compose up --build -d

log "Verifying containers..."
if ! docker-compose ps | grep -q "Up"; then
    log "Error: Containers failed to start properly"
    cleanup
fi

log "Setup completed successfully! ✓"
log "You can access:"
log "- VueJS documentation at https://localhost (HTTPS)"
log "- Development server at http://localhost:4000"
log "- Logs can be viewed with: docker-compose logs -f"
log "Note: Since we're using a self-signed certificate, you may need to accept the security warning in your browser." 