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

    # Create a wrapper script to handle toolbox execution
    echo '#!/bin/bash' > "$BIN_PATH"
    echo 'if [[ "$1" == "update" ]]; then' >> "$BIN_PATH"
    echo '    sudo bash /opt/linux-toolbox/install-toolbox.sh' >> "$BIN_PATH"
    echo 'elif [[ "$1" == "remove" ]]; then' >> "$BIN_PATH"
    echo '    sudo rm -rf /opt/linux-toolbox /usr/local/bin/toolbox' >> "$BIN_PATH"
    echo '    echo "Linux-Toolbox has been removed."' >> "$BIN_PATH"
    echo 'else' >> "$BIN_PATH"
    echo '    bash /opt/linux-toolbox/toolbox.sh "$@"' >> "$BIN_PATH"
    echo 'fi' >> "$BIN_PATH"

    chmod +x "$BIN_PATH"

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
if [[ "$1" == "update" ]]; then
    install_toolbox
    exit 0
elif [[ "$1" == "remove" ]]; then
    remove_toolbox
    exit 0
fi

# Default to install
install_toolbox
