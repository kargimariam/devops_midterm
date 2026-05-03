#!/bin/bash

# DevOps Midterm - Environment Preparation Script (IaC)
# This script automates the installation of runtimes and configurations.

echo " Starting Environment Preparation..."

# 1. Check for Node.js
if ! command -v node &> /dev/null; then
    echo " Node.js not found. Installing..."
    # Commands to install node would go here depending on OS
    # For this simulation, we assume runtimes are available
else
    echo " Node.js Version: $(node -v)"
fi

# 2. Create required directories
echo "Creating project directories..."
mkdir -p logs dist

# 3. Clean and Install Dependencies
echo "Installing dependencies..."
npm install

# 4. Set environment variables
if [ ! -f .env ]; then
    echo "Creating .env from example..."
    cp .env.example .env
fi

# 5. Build the application
echo "Building production assets..."
npm run build

echo " Environment Ready!"
