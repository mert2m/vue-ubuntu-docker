## Technical Details

- Base Image: Ubuntu 22.04 LTS
- Node.js: v18.x
- Web Server: Nginx
- Source: Vue.js v2 Documentation (https://github.com/vuejs/v2.vuejs.org) 

All tests have been conducted on an Ubuntu 22.04 server, and the implementation works as expected without any issues.



## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/mert2m/vue-ubuntu-docker.git
cd vue-ubuntu-docker
```

2. Run the setup script:
```bash
cd scripts
chmod +x all-in-one-setup.sh
./all-in-one-setup.sh
```

3. Access the documentation:
- HTTPS: https://localhost (accept the self-signed certificate warning)
- HTTP: http://localhost:4000

3.1 Reach the containers
```bash
curl -vk https://localhost
curl -vk http://localhost:4000
```

## Architecture

The development environment consists of two Docker containers:
- **App Container**: Runs the Vue.js documentation server (Node.js 18)
- **Nginx Container**: Serves as a reverse proxy with SSL termination

## Features

- Fully automated setup
- Containerized development environment
- HTTPS support with self-signed certificates
- Hot-reload for development
- No manual configuration needed

## Directory Structure

```
.
├── docker/
│   ├── app/
│   │   └── Dockerfile
│   └── nginx/
│       ├── Dockerfile
│       ├── nginx.conf
│       └── ssl/
├── scripts/
│   └── all-in-one-setup.sh
└── docker-compose.yml
```

## Development

The development server supports hot-reload. Any changes made to the Vue.js documentation source will be automatically reflected in the browser.

## Troubleshooting

### SSL Certificate Warning
The development environment uses a self-signed SSL certificate. This is normal and you can safely proceed in your browser by:
1. Clicking "Advanced"
2. Clicking "Proceed to localhost (unsafe)"

