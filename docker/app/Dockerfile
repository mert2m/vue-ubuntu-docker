FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/vuejs/v2.vuejs.org.git . && \
    npm install && \
    npm install -g hexo-cli

ENV HOST=0.0.0.0
ENV PORT=4000

EXPOSE 4000

CMD ["hexo", "server", "--host", "0.0.0.0", "--port", "4000"] 