FROM nginx:stable

# Remove default nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Copy SSL certificates
COPY ssl/nginx-selfsigned.crt /etc/nginx/ssl/
COPY ssl/nginx-selfsigned.key /etc/nginx/ssl/
COPY ssl/dhparam.pem /etc/nginx/ssl/

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"] 