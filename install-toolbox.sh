#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # Reset

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to install required dependencies
install_dependencies() {
    echo -e "${CYAN}Checking for required dependencies...${NC}"
    if ! command_exists git; then
        echo -e "${RED}Git is not installed. Installing Git...${NC}"
        sudo apt-get update && sudo apt-get install -y git
    fi
    if ! command_exists wget; then
        echo -e "${RED}Wget is not installed. Installing Wget...${NC}"
        sudo apt-get install -y wget
    fi
}

# Function to clone or update Linux-Toolbox
install_or_update_toolbox() {
    if [ ! -d "linux-toolbox" ]; then
        echo -e "${CYAN}Cloning Linux-Toolbox from GitHub...${NC}"
        git clone https://github.com/Elpu7/linux-toolbox.git
        cd linux-toolbox || exit 1
        chmod +x toolbox.sh
        echo -e "${GREEN}Installation complete!${NC}"
    else
        echo -e "${CYAN}Updating existing installation...${NC}"
        cd linux-toolbox || exit 1
        git fetch --all
        git reset --hard origin/main
        chmod +x toolbox.sh
        echo -e "${GREEN}Update complete!${NC}"
    fi
}

# Main function
main() {
    # Install dependencies if not already installed
    install_dependencies

    # Install or update the toolbox
    install_or_update_toolbox

    # End of script message
    echo -e "${GREEN}You can now run 'toolbox' command to use Linux-Toolbox.${NC}"
}

# Run the main function
main