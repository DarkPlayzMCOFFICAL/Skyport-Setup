#!/bin/bash

# ASCII Art
read -r -d '' ascii_art <<'EOF'

________                __   __________.__                          _____  _________  
\______ \ _____ _______|  | _\______   \  | _____  ___.__.________ /     \ \_   ___ \ 
 |    |  \\__  \\_  __ \  |/ /|     ___/  | \__  \<   |  |\___   //  \ /  \/    \  \/ 
 |    `   \/ __ \|  | \/    < |    |   |  |__/ __ \\___  | /    //    Y    \     \____
/_______  (____  /__|  |__|_ \|____|   |____(____  / ____|/_____ \____|__  /\______  /
        \/     \/           \/                   \/\/           \/       \/        \/                                 

EOF

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to show messages
echo_message() {
  echo -e "${GREEN}$1${NC}"
}

# Clear the screen
clear

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root.${NC}"
  exit 1
fi

echo -e "${CYAN}$ascii_art${NC}"

echo_message "* Installing Dependencies"

# Update package list and install dependencies
apt update
apt install -y curl software-properties-common
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install nodejs -y 
apt install git -y

echo_message "* Installed Dependencies"

echo_message "* Installing Files"

# Create directory, clone repository, and install files
mkdir -p panel5
cd panel5 || { echo_message "Failed to change directory to skyport"; exit 1; }
git clone https://github.com/achul123/panel5.git
cd panel5 || { echo_message "Failed to change directory to panel"; exit 1; }
npm install

echo_message "* Installed Files"

echo_message "* Starting Skyport"

# Run setup scripts
npm run seed
npm run createUser

echo_message "* Starting Skyport With PM2"

# Install PM2 and start the application
npm install -g pm2
pm2 start index.js

echo_message "* Skyport Installed and Started on Port 3001"

# Clear the screen after finishing
clear
echo -e "${YELLOW}* Made by HimanshuPLayz${NC}"
