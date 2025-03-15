#!/bin/bash

REPO_URL="https://github.com/Elpu7/linux-toolbox.git"
INSTALL_DIR="/opt/linux-toolbox"
BIN_PATH="/usr/local/bin/toolbox"

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script requires root privileges. Please run it with sudo."
   exit 1
fi

# Function to install or update
install_toolbox() {
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

    # Create a symlink for easy access
    ln -sf "$INSTALL_DIR/toolbox.sh" "$BIN_PATH"

    echo "Installation complete. Use 'toolbox' command to run."
}

# Function to remove toolbox
remove_toolbox() {
    echo "Removing Linux-Toolbox..."
    rm -rf "$INSTALL_DIR"
    rm -f "$BIN_PATH"
    echo "Linux-Toolbox has been removed."
}

# Handle command arguments
case "$1" in
    update)
        install_toolbox
        ;;
    remove)
        remove_toolbox
        ;;
    *)
        install_toolbox
        exec "$BIN_PATH"
        ;;
esac
