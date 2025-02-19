FROM nginx:stable

# Remove default nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Create SSL directory with correct permissions
RUN mkdir -p /etc/nginx/ssl && \
    chmod 755 /etc/nginx/ssl

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"] 