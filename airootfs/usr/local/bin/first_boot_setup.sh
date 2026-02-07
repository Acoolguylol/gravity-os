#!/bin/bash

echo "Running GravityOS First Boot Setup..."

# Install Oh-My-Zsh (Network required)
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Configure openCLAW (Moltbot)
    echo "Starting OpenClaw setup wizard..."
    cd /opt/GravityOS/Agents/OpenClaw
    npm install
    # Interactive wizard runs here eventually?
else
    echo "No network connection. Skipping online setup."
fi

echo "Disabling this service..."
systemctl disable gravity-init.service
