#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cleanup() {
    echo -e "\n${RED}[!] Script interrupted. Exiting...${NC}"
    exit 1
}

trap cleanup SIGINT SIGTERM

echo -e "${BLUE}This script will completely reinstall Jenkins on your Arch Linux system.${NC}"
echo -e "${YELLOW}Press Ctrl+C to cancel or wait 10 seconds or Press Enter to continue...${NC}"

read -t 10 -p ""

echo -e "${GREEN}Starting the Jenkins reinstallation process...${NC}"
echo "------------------------------------------------------"

echo -e "${BLUE}Checking internet connection...${NC}"

if ping -c 1 8.8.8.8 &>/dev/null; then
    echo -e "${GREEN}[+] Internet connection detected${NC}"
else
    echo -e "${RED}[!] No internet access. Exiting...${NC}"
    exit 1
fi

# Remove stale pacman lock if safe
if [ -f /var/lib/pacman/db.lck ]; then
    if ! pgrep -x pacman >/dev/null; then
        echo -e "${YELLOW}[*] Removing stale pacman lock...${NC}"
        sudo rm -f /var/lib/pacman/db.lck
    else
        echo -e "${RED}[!] Pacman is currently running. Exiting.${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}Stopping Jenkins service...${NC}"
sudo systemctl stop jenkins 2>/dev/null || true

read -p "This will delete ALL Jenkins data. Continue? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
fi

echo -e "${BLUE}Removing Jenkins package...${NC}"
sudo pacman -Rns jenkins --noconfirm || true

echo -e "${BLUE}Removing Jenkins data...${NC}"
sudo rm -rf /var/lib/jenkins /var/log/jenkins /var/cache/jenkins

echo -e "${BLUE}Removing Jenkins user/group...${NC}"
sudo userdel jenkins 2>/dev/null || true
sudo groupdel jenkins 2>/dev/null || true

echo -e "${BLUE}Installing Jenkins...${NC}"
sudo pacman -Sy --noconfirm jenkins

echo -e "${BLUE}Reloading systemd...${NC}"
sudo systemctl daemon-reload

echo -e "${BLUE}Enabling and starting Jenkins...${NC}"
sudo systemctl enable --now jenkins

echo -e "${GREEN}[+] Jenkins installed successfully${NC}"

echo -e "${BLUE}Access Jenkins at: http://127.0.0.1:8090${NC}"

echo -e "${BLUE}Fetching initial admin password...${NC}"

for i in {1..20}; do
    PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || true)

    if [ -n "$PASSWORD" ]; then
        echo -e "${GREEN}Initial Admin Password:${NC} $PASSWORD"
        exit 0
    fi

    echo -e "${YELLOW}[*] Waiting for Jenkins to generate password...${NC}"
    sleep 3
done

echo -e "${RED}[!] Timed out waiting for Jenkins password.${NC}"

echo -e "${YELLOW}Check service status:${NC}"
echo "sudo systemctl status jenkins"
