# Use the official Nginx image as the base image
FROM nginx:alpine

# Copy your HTML files to the default directory Nginx serves from
COPY ./ /usr/share/nginx/html/

# Expose port 80 to make the web app accessible
EXPOSE 80