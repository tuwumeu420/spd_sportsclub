#!/bin/bash

# DEFINE VARIABLES
NGINX_CONF="./docker/nginx/nginx.conf"
COMPOSE_CMD="docker compose -f docker-compose.yml -f docker-compose.production.yml"

# WHICH ACTIVE STREAM NOW?
if grep -q "server app-blue:8080;" "$NGINX_CONF"; then
    CURRENT="blue"
    TARGET="green"
else
    CURRENT="green"
    TARGET="blue"
fi

# SPIN NEW DEPLOYED TAG
echo "🐳 UPDATING -$TARGET..."
$COMPOSE_CMD pull "app-$TARGET"
$COMPOSE_CMD up -d "app-$TARGET"
sleep 5


# CHANGE ACTIVE UPSTREAM 'upstream app_active'
sed -i "/upstream app_active {/,/}/ s/app-$CURRENT/app-$TARGET/" "$NGINX_CONF"

# RELOAD NGINX
echo "Reloading Nginx..."
docker compose exec nginx nginx -s reload
