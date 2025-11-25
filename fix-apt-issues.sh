#!/bin/bash

# Fix Ubuntu apt repository issues
# Run this if you encounter mirror sync errors

set -e

echo "🔧 Fixing apt repository issues..."

# Method 1: Clear apt cache and retry
echo "Step 1: Clearing apt cache..."
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get clean

# Method 2: Update with fix-missing flag
echo "Step 2: Updating package lists (with fix-missing)..."
sudo apt-get update --fix-missing || true

# Method 3: If still failing, try updating sources to use main Ubuntu mirror
echo "Step 3: Checking if we need to update sources..."

# Backup current sources
if [ ! -f /etc/apt/sources.list.backup ]; then
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
fi

# Wait a moment for mirror sync to complete
echo "Waiting 10 seconds for mirror sync to complete..."
sleep 10

# Retry update
echo "Step 4: Retrying package list update..."
sudo apt-get update

# If still failing, try using different mirrors
if [ $? -ne 0 ]; then
    echo "Step 5: Trying alternative approach - updating to use main Ubuntu archive..."
    
    # For Ubuntu 24.04 (Noble)
    sudo sed -i 's|http://security.ubuntu.com/ubuntu|http://archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list.d/*.list 2>/dev/null || true
    sudo sed -i 's|http://security.ubuntu.com/ubuntu|http://archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list 2>/dev/null || true
    
    sudo apt-get update
fi

echo "✅ Apt repository issues should be fixed!"
echo "You can now continue with the deployment."

