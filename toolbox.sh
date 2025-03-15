#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m' # Reset

while true; do
    clear
    echo -e "${CYAN}=== Linux Toolbox ===${NC}"
    echo "1) System Info"
    echo "2) Network Info"
    echo "3) Resource Monitor"
    echo "4) Exit"
    echo -n "Choose an option: "
    read choice

    case $choice in
        1)
            echo -e "${CYAN}=== System Info ===${NC}"
            echo -e "${CYAN}OS:${NC} $(lsb_release -d | cut -f2-)"
            echo -e "${CYAN}Kernel:${NC} $(uname -r)"
            echo -e "${CYAN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d ':' -f2- | sed 's/^ *//')"
            echo -e "${CYAN}GPU:${NC} $(lspci | grep -i vga | cut -d ':' -f3- | sed 's/^ *//')"
            echo -e "${CYAN}RAM:${NC} $(free -h | grep Mem | awk '{print $2}') total, $(free -h | grep Mem | awk '{print $3}') used"
            echo -e "${CYAN}Disk Space:${NC} $(df -h / | tail -1 | awk '{print $2}') total, $(df -h / | tail -1 | awk '{print $3}') used"
            echo -e "${CYAN}Up Time:${NC} $(uptime -p)"
            echo -e "${CYAN}Terminal:${NC} $(tty)"
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

            
            cpu_line=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
            ram_line=$(free -h | grep Mem | awk '{print "Used: " $3 " / " $2}')
            
            
            echo -e "${CYAN}CPU Usage: ${NC}$cpu_line"
            echo -e "${CYAN}RAM Usage: ${NC}$ram_line"
            
            
            while true; do
                
                tput cuu 2
                
                cpu_line=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
                ram_line=$(free -h | grep Mem | awk '{print "Used: " $3 " / " $2}')
                
                
                echo -e "${CYAN}CPU Usage: ${NC}$cpu_line"
                echo -e "${CYAN}RAM Usage: ${NC}$ram_line"
                
                sleep 1
            done
            ;;
        
        4)
            echo -e "${RED}Exiting...${NC}"
            exit 0 ;;
        
        *)
            echo -e "${RED}Invalid option! Try again.${NC}"
            sleep 1 ;;
    esac
done