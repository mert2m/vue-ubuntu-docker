## Important Notes

This script is designed to run on a system where Docker and Docker Compose are not installed. It will handle their installation and configuration for you.

The script runs in two stages!
The first time you run the script, it adds your user to the docker group. This change requires you to log out and log back in before the second run.

All tests have been conducted on an Ubuntu 22.04 server, and the implementation works as expected without any issues.


## Technical Details

- Base Image: Ubuntu 22.04 LTS
- Node.js: v18.x
- Web Server: Nginx
- Source: Vue.js v2 Documentation (https://github.com/vuejs/v2.vuejs.org) 



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
|── docker-compose.yml
|── dockerized-app.drawio.png

```

## Development

The development server supports hot-reload. Any changes made to the Vue.js documentation source will be automatically reflected in the browser.

## Troubleshooting

### SSL Certificate Warning
The development environment uses a self-signed SSL certificate. This is normal and you can safely proceed in your browser by:
1. Clicking "Advanced"
2. Clicking "Proceed to localhost (unsafe)"


## Draw.io Link

If you cannot see the dockerized-app.drawio.png file, you can access it via the following link.


https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=dockerized-app.drawio&dark=auto#R%3Cmxfile%3E%3Cdiagram%20name%3D%22Page-1%22%20id%3D%22fGfDeVXLDX98E72cWIVe%22%3EzVjZbts4FP0aA%2FGDDK1eHr1OW6RBUGe2R1piJY5pUUNRljxfP5ciJWtr0ilGbYMgIs%2Fles7RJZWJs70Uv3CURB9ZgOnENoNi4uwmtr20TfgrgZsCPHelgJCTQEHWHTiSf7AGdb8wIwFOWw0FY1SQpA36LI6xL1oY4pzl7WafGW3PmqAQ94Cjj2gf%2FZ0EItLb8sw7%2Fg6TMKpmtkwduaCqsQbSCAUsb0DOfuJsOWNClS7FFlPJXcWL6nf4QrReGMex%2BJoOp8f3m48v1JufP9j5AX8iuWUaFc1XRDO9Y71acasoCDnLEt0Mc4GLIeLRqWpu9hdm1dsFm2B2wYLfoElRc6a6aIu4uprf%2BV5UrEYNrt1KBKQ1Duuh7zRAQTPxX1jpkbJj%2FhlzwN6xVMDj4ddTFosMSrY9M91pjzRQO5FFLrmJQwlvgMc4wHJiC2qp4OyMt4wyXnZxzPIHIp8JpQ18N9%2BvD0uJs1joN8Ryq7qeUo4o1SFg3TUlYQyYYAmgX1SuqdAr5ujr9qYw5ljCuG%2B7tU1yHhGBjwnyZTSHDAVYJC5Uh%2F9%2FbvQwTtvS876l5%2B4Ac%2FZolrZ7zD2FJC4A2oKLEImlu%2BfgNks60AC87fBO8Hh8hGW8PB47%2BCcMZKYYSs%2BcFbdO9JlxARtbQ3EJG4WdmK7rjPnuHFb7xerQeXfsMZV328ov%2BsrXIjeVt0ZT3ukp%2F1uGZ3%2Bl3yr9Exzxqru1HNBXyetKNdrBetarXA4k1HRM4der3WHzfYW3fjblvYFsOacw7SYg1xbz878zeQ3ZACfCQOr4kDL6wAi4Q7JWNYFSqJ%2FlUKfBgU7IP4eldIavRJHDCY7itOJ5U14e6hiVjBgB4ucHHp4edHqoHlP1lBHb81SlWZhO1YDlBmSeNy5gUzVyzHTiL%2B9%2FsTDS0g4yZLlJMbi7%2Brx%2FwiJn%2FCyPfJQkRqyq02r3oMupywhgJb8V2jG5XOIPPJm6R5O9HPDpYsCnzlg2XfRsupH3dkn%2FYQfnCWVJK0O9cBKGpTg7nFB2u0g%2B4EjyOUlEo90M%2BiNKDRIbLMZGikWWzNKok5b8jMsVGlepcSREog6oA%2FxSBpepqLzwvd5loIezVilwvAy3n2%2FM9fr7Hm1t6zhe3zrO0IXQGu1CuOwxjAP4ftNVTE8s39%2BBr6YaaOK3PwCsK3%2FKysyrqruiGdzddE2tRi7hW4iH9IV4iF9r6AwLxDFFglzbsw6Rrbs%2BM1K%2BM1VOWLWFtVx35rUHSVnGfaz7Nb8yO0M5izeHUpvsDVXqX%2B9pyBJQvX8uq%2Bb3%2Fzk4%2B38B%3C%2Fdiagram%3E%3C%2Fmxfile%3E