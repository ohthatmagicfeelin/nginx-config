#!/bin/bash

# Set server details
SERVER="vps"
NGINX_PATH="/etc/nginx"
BACKUP_FILE="sites-available.bak"

# Generate production config
echo "Generating production configuration..."
./generate-config.sh .env

echo "Starting sync process..."

# Create backup on remote
echo "Creating backup on remote server..."
ssh $SERVER "sudo cp -r $NGINX_PATH/sites-available $NGINX_PATH/$BACKUP_FILE"

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Sync new configuration
echo "Copying new configuration..."
rsync -av \
    --exclude='*.template' \
    --exclude='*.example' \
    ${SCRIPT_DIR}/sites-available/ $SERVER:$NGINX_PATH/sites-available.test/

# Test new configuration on remote
echo "Testing new configuration..."
ssh $SERVER "sudo nginx -t" 

if [ $? -eq 0 ]; then
    echo "Configuration test passed. Reloading Nginx..."
    ssh $SERVER "sudo systemctl reload nginx"
    echo "Sync completed successfully!"
else
    echo "Configuration test failed. Rolling back to previous configuration..."
    ssh $SERVER "sudo rm -rf $NGINX_PATH/sites-available && \
                 sudo mv $NGINX_PATH/$BACKUP_FILE $NGINX_PATH/sites-available && \
                 sudo nginx -t && \
                 sudo systemctl reload nginx"
    echo "Rollback completed. Previous configuration restored."
    exit 1
fi