# ===========================================
# Frontend Dockerfile - Nginx Static Server
# ===========================================
FROM nginx:alpine

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy static files
COPY public/ /usr/share/nginx/html/

# Copy nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
