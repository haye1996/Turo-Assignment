FROM nginx:alpine

# Install curl for testing
RUN apk add --no-cache curl

# Copy static files to nginx html directory
COPY app/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 