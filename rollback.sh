#!/bin/bash

# Rollback Script
# Reverts the production environment to the previous backup

DEPLOY_DIR="deployments"
BLUE_DIR="$DEPLOY_DIR/blue"
BACKUP_DIR="$DEPLOY_DIR/rollback_v"
ACTIVE_SYMLINK="production"

echo "ROLLBACK INITIATED..."

if [ -d "$BACKUP_DIR" ]; then
    echo "Restoring previous version from backup..."
    # On Windows, we use rm/cp instead of mv to avoid permission locks
    rm -rf "$BLUE_DIR"
    mkdir -p "$BLUE_DIR"
    cp -r "$BACKUP_DIR/." "$BLUE_DIR/"
    
    # Update production folder
    rm -rf "$ACTIVE_SYMLINK"
    mkdir -p "$ACTIVE_SYMLINK"
    cp -r "$BLUE_DIR/." "$ACTIVE_SYMLINK/"
    
    echo "Rollback complete. Traffic restored to previous version."
else
    echo "ERROR: No backup version found to rollback to!"
    exit 1
fi
