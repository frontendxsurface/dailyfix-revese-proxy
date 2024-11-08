# Use the official Nginx base image
FROM nginx:latest

# Copy the custom default.conf to the Nginx configuration directory
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy static HTML files to the Nginx web root
COPY html /usr/share/nginx/html