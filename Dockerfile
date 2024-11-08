# Dockerfile
FROM nginx:latest

# Install Certbot and cron for SSL auto-renewal
RUN apt-get update && apt-get install -y certbot cron

# Copy the custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy static HTML files
COPY html /usr/share/nginx/html

# Add a cron job to renew the certificates periodically
COPY renew_certs.sh /etc/cron.daily/renew_certs.sh
RUN chmod +x /etc/cron.daily/renew_certs.sh

# Expose the necessary ports
EXPOSE 80 443

# Start Nginx and Cron services
CMD ["sh", "-c", "cron && nginx -g 'daemon off;'"]
