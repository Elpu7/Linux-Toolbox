#!/bin/bash

# Värit
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # Reset

while true; do
    clear
    echo -e "${CYAN}=== Linux Toolbox ===${NC}"
    echo "1) System Info"
    echo "2) Network Info"
    echo "3) Resource Monitor"
    echo "4) Firewall Management"
    echo "5) Exit"
    echo -n "Choose an option: "
    read choice

    case $choice in
        1)
            echo -e "${CYAN}=== System Info ===${NC}"
            echo -e "${CYAN}OS:${NC} $(lsb_release -d | cut -f2-)"
            echo -e "${CYAN}Kernel:${NC} $(uname -r)"
            echo -e "${CYAN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d ':' -f2- | sed 's/^ *//')"
            echo -e "${CYAN}CPU Cores:${NC} $(nproc)"
            echo -e "${CYAN}RAM:${NC} $(free -h | grep Mem | awk '{print $2}') total, $(free -h | grep Mem | awk '{print $3}') used"
            echo -e "${CYAN}Disk Space:${NC} $(df -h / | tail -1 | awk '{print $2}') total, $(df -h / | tail -1 | awk '{print $3}') used"
            echo -e "${CYAN}Up Time:${NC} $(uptime -p)"
            echo -e "${CYAN}Boot Time:${NC} $(who -b | awk '{print $3, $4}')"
            echo -e "${CYAN}Terminal:${NC} $(tty)"
            echo -e "${CYAN}Package Manager:${NC} $(command -v apt &> /dev/null && echo "apt" || command -v dnf &> /dev/null && echo "dnf" || command -v pacman &> /dev/null && echo "pacman" || echo "Unknown")"
            echo -e "${GREEN}Press enter to continue...${NC}"
            read ;;
        
        2)
            echo -e "${CYAN}=== Network Info ===${NC}"
            echo -e "${CYAN}Local IP:${NC} $(hostname -I | awk '{print $1}')"
            echo -e "${CYAN}Public IP:${NC} $(curl -s ifconfig.me)"
            echo "Connected Interfaces:"
            ip a | grep "state UP" -A2
            echo -e "${GREEN}Press enter to continue...${NC}"
            read ;;
        
        3)
            echo -e "${GREEN}=== Resource Monitor (Ctrl+C to exit) ===${NC}"
            while true; do
                cpu_line=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
                ram_line=$(free -h | grep Mem | awk '{print "Used: " $3 " / " $2}')
                
                clear
                echo -e "${CYAN}CPU Usage: ${NC}$cpu_line"
                echo -e "${CYAN}RAM Usage: ${NC}$ram_line"
                
                sleep 1
            done
            ;;
        
        4)
            while true; do
                clear
                echo -e "${CYAN}=== Firewall Management ===${NC}"
                if command -v ufw &> /dev/null; then
                    firewall_status=$(sudo ufw status | head -n 1)
                    echo -e "${CYAN}Firewall Status:${NC} $firewall_status"
                    echo "1) Enable Firewall"
                    echo "2) Disable Firewall"
                    echo "3) List Rules"
                    echo "4) Allow Port (e.g., 22)"
                    echo "5) Deny Port (e.g., 22)"
                    echo "6) Back to Main Menu"
                    echo -n "Choose an option: "
                    read fw_choice

                    case $fw_choice in
                        1) sudo ufw enable; read -p "Firewall enabled. Press enter to continue...";;
                        2) sudo ufw disable; read -p "Firewall disabled. Press enter to continue...";;
                        3) sudo ufw status numbered; read -p "Press enter to continue...";;
                        4) 
                            echo -n "Enter port number to allow: "; read port
                            sudo ufw allow "$port"
                            read -p "Port $port allowed. Press enter to continue..."
                            ;;
                        5) 
                            echo -n "Enter port number to deny: "; read port
                            sudo ufw deny "$port"
                            read -p "Port $port denied. Press enter to continue..."
                            ;;
                        6) break ;;
                        *) echo -e "${RED}Invalid option! Try again.${NC}"; sleep 1 ;;
                    esac
                else
                    echo -e "${RED}UFW is not installed.${NC}"
                    echo "Would you like to install it? (y/n)"
                    read install_choice
                    if [[ $install_choice == "y" ]]; then
                        sudo apt install ufw -y || sudo dnf install ufw -y || sudo pacman -S ufw --noconfirm
                        echo -e "${GREEN}UFW installed successfully!${NC}"
                    fi
                    read -p "Press enter to continue..."
                    break
                fi
            done
            ;;
        
        5)
            echo -e "${RED}Exiting...${NC}"
            exit 0 ;;
        
        *)
            echo -e "${RED}Invalid option! Try again.${NC}"
            sleep 1 ;;
    esac
done
