#!/bin/bash


set -e


log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

get_docker_compose_cmd() {
    if command -v docker-compose &>/dev/null; then
        echo "docker-compose"
    elif command -v docker &>/dev/null && docker compose version &>/dev/null; then
        echo "docker compose"
    else
        log "Error: Docker Compose is not installed!"
        exit 1
    fi
}

# Function to verify Docker permissions
verify_docker_permissions() {
    if ! groups | grep -q docker; then
        log "Adding user to docker group..."
        sudo usermod -aG docker $USER
        log "⚠️  Please log out and log back in for the group changes to take effect"
        log "After logging back in, run this script again"
        exit 0
    fi

    # Test Docker access
    if ! docker info &>/dev/null; then
        log "Testing Docker access with sudo..."
        if ! sudo docker info &>/dev/null; then
            log "Error: Cannot access Docker daemon. Please ensure Docker is running"
            exit 1
        else
            log "⚠️  Docker daemon is accessible only with sudo"
            log "Please log out and log back in for group changes to take effect"
            exit 1
        fi
    fi
}

install_docker() {
    log "Installing Docker and Docker Compose..."

    sudo apt update -y
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER

    # Install Docker Compose (latest version)
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    log "Docker and Docker Compose installed successfully! ✓"
    log "⚠️  Please log out and log back in for the group changes to take effect"
    log "After logging back in, run this script again"
    exit 0
}

check_requirements() {
    log "Checking system requirements..."
    
    if [[ "$(uname)" != "Linux" && "$(uname)" != "Darwin" ]]; then
        log "Error: This script is designed to run on Linux or macOS systems"
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        log "Docker is not installed. Installing now..."
        install_docker
    fi

    if ! command -v docker-compose &> /dev/null && ! command -v docker &> /dev/null && ! docker compose version &> /dev/null; then
        log "Docker Compose is not installed. Installing now..."
        install_docker
    fi

    verify_docker_permissions

    if ! command -v openssl &> /dev/null; then
        log "Error: OpenSSL is not installed. Installing now..."
        sudo apt update -y && sudo apt install -y openssl
    fi

    log "All system requirements met ✓"
}

generate_ssl_certificates() {
    log "Setting up SSL certificates..."
    
    CURRENT_DIR=$(pwd)
    SSL_DIR="$CURRENT_DIR/../docker/nginx/ssl"
    
    log "Creating SSL directory..."
    rm -rf "$SSL_DIR"
    mkdir -p "$SSL_DIR"
    
    log "Generating SSL certificate and key..."
    cd "$SSL_DIR"
    
    openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout nginx-selfsigned.key \
        -out nginx-selfsigned.crt \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
    
    if [ ! -f "nginx-selfsigned.crt" ] || [ ! -f "nginx-selfsigned.key" ]; then
        log "Failed to generate SSL certificate files!"
        exit 1
    fi
    
    chmod 644 nginx-selfsigned.crt
    chmod 600 nginx-selfsigned.key
    
    cd "$CURRENT_DIR"
    
    log "SSL certificates generated successfully ✓"
}

cleanup() {
    log "Error occurred. Cleaning up..."
    $DOCKER_COMPOSE_CMD down --remove-orphans &> /dev/null || true
    exit 1
}

trap cleanup ERR

# Main setup process
main() {
    log "Starting development environment setup..."
    check_requirements

    # Determine which Docker Compose command to use
    DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    log "Using Docker Compose command: $DOCKER_COMPOSE_CMD"

    # Generate SSL certificates
    generate_ssl_certificates

    log "Stopping any existing containers..."
    $DOCKER_COMPOSE_CMD down --remove-orphans &> /dev/null || true

    log "Building and starting containers..."
    $DOCKER_COMPOSE_CMD up --build -d

    log "Verifying containers..."
    if ! $DOCKER_COMPOSE_CMD ps | grep -q "Up"; then
        log "Error: Containers failed to start properly"
        cleanup
    fi

    log "Setup completed successfully! ✓"
    log "You can access:"
    log "- VueJS documentation at https://localhost (HTTPS)"
    log "- Development server at http://localhost:4000"
    log "- Logs can be viewed with: $DOCKER_COMPOSE_CMD logs -f"
    log "Note: Since we're using a self-signed certificate, you may need to accept the security warning in your browser."
}


main
