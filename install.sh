#!/bin/bash
clear

# Check if package is installed (assuming pacman for simplicity, adjust if needed)
is_installed_pacman() {
    local package="$1"
    if pacman -Qs "${package}" > /dev/null; then
        return 0 # true
    else
        return 1 # false
    fi
}

# Install required packages (assuming pacman for simplicity, adjust if needed)
install_packages_pacman() {
    local to_install=()
    for pkg in "$@"; do
        if is_installed_pacman "${pkg}"; then
            echo "${pkg} is already installed."
        else
            to_install+=("${pkg}")
        fi
    done
    if [ ${#to_install[@]} -eq 0 ]; then
        echo "All required packages are already installed."
        return
    fi
    echo "Packages to be installed: ${to_install[@]}"
    sudo pacman --noconfirm -S "${to_install[@]}"
}

# Required packages for the installer
packages=(
    "wget"
    "unzip"
    "gum"
    "jq"
    "fuse2"
    "gtk4"
    "libadwaita"
    "python"
    "python-gobject"
)

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ___           _        _ _           
|_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 | || '_ \/ __| __/ _` | | |/ _ \ '__|
 | || | | \__ \ || (_| | | |  __/ |   
|___|_| |_|___/\__\__,_|_|_|\___|_|   
                                      
EOF
echo "for Hypr Settings App"
echo
echo -e "${NONE}"
echo "This script will support you to download and install the Hypr Settings App."
echo

# Assuming you want to proceed with installation without asking user interactively
# Comment out the following block if you want to keep user interaction
# while true; do
#     read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
#     case $yn in
#         [Yy]* )
#             echo "Installation started."
#             echo
#         break;;
#         [Nn]* )
#             echo "Installation canceled."
#             exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

# Synchronizing package databases (assuming pacman for simplicity, adjust if needed)
sudo pacman -Sy
echo

# Install required packages
echo ":: Checking that required packages are installed..."
install_packages_pacman "${packages[@]}"
echo

# Ensure the applications directory exists
if [ ! -d "$HOME/.local/share/applications/" ]; then
    mkdir -p "$HOME/.local/share/applications/"
    echo ":: $HOME/.local/share/applications/ created"
fi

# Ensure the Hypr config apps directory exists
if [ ! -d "$HOME/.config/hypr/apps" ]; then
    mkdir -p "$HOME/.config/hypr/apps"
    echo ":: apps folder created in $HOME/.config/hypr/apps"
fi

# Ensure the Hypr config imgs directory exists
if [ ! -d "$HOME/.config/hypr/imgs" ]; then
    mkdir -p "$HOME/.config/hypr/imgs"
    echo ":: imgs folder created in $HOME/.config/hypr/imgs"
fi

# Copy files to the appropriate locations
cp hypr-settings "$HOME/.config/hypr/apps/"
cp -r screenshots "$HOME/.config/hypr/apps/"
cp -r usr "$HOME/.config/hypr/apps/"
cp icon.png "$HOME/.config/hypr/imgs/hypr-settings.png"
cp hypr-blizz-settings.desktop "$HOME/.local/share/applications/"

# Make sure AppRun is executable
chmod +x "$HOME/.config/hypr/apps/hypr-settings"

APP="$HOME/.config/hypr/apps/hypr-settings"
ICON="$HOME/.config/hypr/imgs/hypr-settings.png"
sed -i "s|Exec=HOME|Exec=${APP}|g" "$HOME/.local/share/applications/hypr-settings.desktop"
echo ":: Desktop file installed successfully in ~/.local/share/applications"

echo 
echo "DONE!" 
echo "Please add the following command to your hyprland.conf if you want to restore the changes after logging in."
echo "exec-once = ~/.config/hypr-settings/hyprctl.sh"
echo 
echo "You can start the app from your application launcher or with the terminal from the folder apps with:"
echo "./hypr-settings"
