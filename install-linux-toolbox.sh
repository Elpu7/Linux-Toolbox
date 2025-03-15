#!/bin/bash

REPO_URL="https://github.com/Elpu7/linux-toolbox.git"  # Replace with your repository URL
INSTALL_DIR="/opt/linux-toolbox"
BIN_PATH="/usr/local/bin/toolbox"

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script requires root privileges. Please run it with sudo."
   exit 1
fi

echo "Downloading Linux-Toolbox from GitHub..."
if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull
else
    echo "Installing in: $INSTALL_DIR"
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Set execution permissions
chmod +x "$INSTALL_DIR/toolbox.sh"

# Create a symlink to make it accessible system-wide
ln -sf "$INSTALL_DIR/toolbox.sh" "$BIN_PATH"

echo "Installation complete. You can now use the toolbox command."
