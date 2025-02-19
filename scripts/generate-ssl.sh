#!/bin/bash

# Exit on any error
set -e

# SSL certificate directory
SSL_DIR="./docker/nginx/ssl"

# Create SSL directory if it doesn't exist
mkdir -p $SSL_DIR

# Generate self-signed certificate
openssl req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout $SSL_DIR/nginx-selfsigned.key \
    -out $SSL_DIR/nginx-selfsigned.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Generate strong Diffie-Hellman group
openssl dhparam -out $SSL_DIR/dhparam.pem 2048

echo "SSL certificates generated successfully!" 