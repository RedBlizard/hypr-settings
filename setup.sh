#!/bin/bash
clear

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|    
EOF
echo "for Hypr Settings App"
echo
echo -e "${NONE}"

# Prompt user to start installation
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
            echo
            break;;
        [Nn]* )
            echo "Installation canceled."
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Change into your Home directory
cd ~ || { echo "Error: Failed to change directory to home."; exit 1; }

# Remove existing folder if it exists
if [ -d hypr-settings ]; then
    rm -rf hypr-settings
    echo ":: Existing hypr-settings directory removed"
fi

# Clone the repository
git clone --depth 1 https://github.com/RedBlizard/hypr-settings.git
if [ $? -ne 0 ]; then
    echo "Error: Failed to clone repository."
    exit 1
fi

# Ensure the Hypr config apps directory exists
mkdir -p ~/.config/hypr/apps
if [ $? -ne 0 ]; then
    echo "Error: Failed to create directory ~/.config/hypr/apps"
    exit 1
else
    echo ":: Created directory ~/.config/hypr/apps"
fi

# Change into the cloned directory
cd hypr-settings || { echo "Error: Failed to change directory to hypr-settings."; exit 1; }

# Run the installation script
./install.sh
if [ $? -ne 0 ]; then
    echo "Error: Installation script failed."
    exit 1
fi

echo ":: Installation completed successfully."
