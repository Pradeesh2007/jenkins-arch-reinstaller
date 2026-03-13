#!/bin/bash
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
echo '------------------------------------------------------'
echo -e "${BLUE}Checking the internet connection...${NC}"
if ping -c 1 8.8.8.8 &> /dev/null
then 
	echo -e "${GREEN}[+] Internet connection detected. Continue and Running the main script...${NC}"
else
	echo -e "${RED}[!] No internet access.  Exiting...${NC}"
	exit 1
fi
sudo systemctl stop jenkins >/dev/null && echo -e "${GREEN}[+] Stopped Jenkins services successfully${NC}"

sudo pacman -Rns jenkins --noconfirm > /dev/null && echo -e "${GREEN}[+] Jenkins removed successfully${NC}"

sudo rm -rf /var/lib/jenkins /var/log/jenkins /var/cache/jenkins  && echo -e "${GREEN}[+] Jenkins Data folders removed successfully${NC}"
sudo userdel jenkins 2>/dev/null && sudo groupdel jenkins 2>/dev/null && echo -e "${GREEN}[+] Jenkins user and group was deleted${NC}"
echo -e "${GREEN}[+] Reinstalling Jenkins${NC}"  && sudo pacman -S jenkins --noconfirm > /dev/null && echo -e "${GREEN}[+] Installed${NC}"
sudo systemctl daemon-reload && echo -e "${GREEN}[+] System daemons reloaded${NC}"
sudo systemctl start jenkins && echo -e "${GREEN}[+] Jenkins was reinstalled and started successfully.....${NC}"
echo -e "${BLUE}To Access: http://127.0.0.1:8090${NC}"
echo -e "${BLUE}Fetching the initial admin password...${NC}"

while true; do
    PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null)

    if [ -n "$PASSWORD" ]; then
        echo -e "${GREEN}The Initial Admin Password: $PASSWORD${NC}"
        break
    fi

    echo -e "${YELLOW}[*] Waiting for Jenkins to generate password...${NC}"
    sleep 3
done