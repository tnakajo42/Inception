#!/bin/sh

set -e

# Check that the template exists
if [ ! -f /etc/nginx/http.d/default.conf.template ]; then
    echo "[ERROR] Template file missing: /etc/nginx/http.d/default.conf.template"
    ls -l /etc/nginx/http.d
    exit 1
fi

# Replace placeholder
envsubst '${DOMAIN_NAME}' < /etc/nginx/http.d/default.conf.template > /etc/nginx/http.d/default.conf

# Show final config for debugging
echo "[INFO] Final nginx config:"
cat /etc/nginx/http.d/default.conf

# Start nginx
exec nginx -g 'daemon off;'
