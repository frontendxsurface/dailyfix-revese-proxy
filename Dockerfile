# Dockerfile
FROM nginx:latest

# install certbot
RUN apt-get update && apt-get install -y certbot 
RUN apt-get install -y python3-certbot-nginx
# install cron for auto renew
RUN apt-get install -y cron

# Copy the custom Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy static HTML files
COPY html /usr/share/nginx/html

COPY ./renew_certs.sh /usr/local/bin/renew_certs.sh
RUN chmod +x /usr/local/bin/renew_certs.sh

# เพิ่ม cron job สำหรับ renew_cert.sh
RUN echo "0 0 * * * /usr/local/bin/renew_cert.sh" | crontab -