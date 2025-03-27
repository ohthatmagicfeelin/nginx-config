#!/bin/bash

# Exit on any error
set -e

# Define the source (OneDrive) and target (local repo) paths
ONEDRIVE_PATH="/Users/oh/Library/CloudStorage/OneDrive-Personal/code/webdev/envs/nginx-config"
REPO_PATH="$(pwd)"

# Verify OneDrive path exists
if [ ! -d "$ONEDRIVE_PATH" ]; then
    echo "Error: OneDrive path does not exist: $ONEDRIVE_PATH"
    exit 1
fi

echo "Setting up symlinks..."
echo "Source: $ONEDRIVE_PATH"
echo "Target: $REPO_PATH"

# Function to create symlink
create_symlink() {
    local src="$1"
    local dst="$2"
    
    # Skip .DS_Store files
    if [[ "$(basename "$src")" == ".DS_Store" ]]; then
        return 0
    fi
    
    # Check if source file exists
    if [ ! -f "$src" ]; then
        echo "Error: Source file does not exist: $src"
        return 1
    fi
    
    # Remove existing file/symlink if it exists
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        rm -f "$dst"
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$dst")"
    
    # Create the symlink
    ln -s "$src" "$dst"
    echo "Created symlink: $dst -> $src"
}

# Create symlinks for each dotfile
# VSCode settings
create_symlink "$ONEDRIVE_PATH/.vscode/settings.json" "$REPO_PATH/.vscode/settings.json"

# Root .env file
create_symlink "$ONEDRIVE_PATH/.env" "$REPO_PATH/.env"

echo "Symlink setup complete!"