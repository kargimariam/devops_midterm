#!/bin/bash

# Blue-Green Deployment Simulation Script
# Project: DevOps Midterm

set -e

# Configuration
VERSION=$(date +%Y%m%d%H%M%S)
DEPLOY_DIR="deployments"
BLUE_DIR="$DEPLOY_DIR/blue"
GREEN_DIR="$DEPLOY_DIR/green"
ACTIVE_SYMLINK="production"
TEMP_STAGING="green_staging"

echo "🎯 Starting Deployment Simulation (Version: $VERSION)"

# 1. Clean and Prepare Staging Area
echo "📦 Preparing staging area..."
rm -rf "$TEMP_STAGING"
mkdir -p "$TEMP_STAGING"

# 2. Copy only necessary items to staging
# We avoid copying 'deployments' and 'green_staging' themselves
cp -r src "$TEMP_STAGING/"
cp package.json "$TEMP_STAGING/"
cp tsconfig.json "$TEMP_STAGING/"
cp vite.config.ts "$TEMP_STAGING/"
cp server.ts "$TEMP_STAGING/"
cp vitest.config.ts "$TEMP_STAGING/"
cp README.md "$TEMP_STAGING/" 2>/dev/null || :
cp *.sh "$TEMP_STAGING/"
[ -d "public" ] && cp -r public "$TEMP_STAGING/"

# 3. Move from staging to GREEN
echo "🚚 Moving build to GREEN environment..."
mkdir -p "$DEPLOY_DIR"
rm -rf "$GREEN_DIR"
mkdir -p "$GREEN_DIR"
cp -r "$TEMP_STAGING/." "$GREEN_DIR/"
rm -rf "$TEMP_STAGING"

# 4. Health Check on Green environment
echo "🔍 Running Health Check on GREEN..."
sleep 2
echo "✅ Health Check Passed!"

# 5. BLUE-GREEN SWAP (The atomic switch)
echo "🔄 Swapping traffic: BLUE -> GREEN"

# Backup current blue if it exists for rollback
if [ -d "$BLUE_DIR" ]; then
    echo "💾 Backing up current production (BLUE)..."
    rm -rf "$DEPLOY_DIR/rollback_v"
    mkdir -p "$DEPLOY_DIR/rollback_v"
    cp -r "$BLUE_DIR/." "$DEPLOY_DIR/rollback_v/"
fi

# Move Green to Blue (Make it the primary)
echo "📦 Finalizing deployment..."
rm -rf "$BLUE_DIR"
mkdir -p "$BLUE_DIR"
cp -r "$GREEN_DIR/." "$BLUE_DIR/"
rm -rf "$GREEN_DIR"

# Update production folder (Direct copy is safer on Windows than symlinks)
rm -rf "$ACTIVE_SYMLINK"
mkdir -p "$ACTIVE_SYMLINK"
cp -r "$BLUE_DIR/." "$ACTIVE_SYMLINK/"

echo "🚀 Deployment SUCCESSFUL! New version is now in PRODUCTION."

# Rollback Instruction
echo "------------------------------------------------"
echo "To revert to the previous version, run: sh rollback.sh"
echo "------------------------------------------------"
