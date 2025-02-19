FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Node.js 18.x and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Clone VueJS documentation repository
RUN git clone https://github.com/vuejs/v2.vuejs.org.git . && \
    npm install

# Set host to 0.0.0.0 to allow external access
ENV HOST=0.0.0.0

# Expose port 4000 for development server
EXPOSE 4000

# Start development server with host 0.0.0.0
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"] 