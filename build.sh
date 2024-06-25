#!/bin/bash

# Create a temporary directory
tmp_dir=$(mktemp -d)

# Copy the current repository to the temporary directory
cp -r . "$tmp_dir"

# Remove unnecessary files and directories from the temporary directory
rm -rf "$tmp_dir/.git"
rm -rf "$tmp_dir/screenshots"
rm "$tmp_dir/.gitignore"
rm "$tmp_dir/build.sh"
rm "$tmp_dir/install.sh"

# Ensure the Hypr config apps directory exists
mkdir -p ~/.config/hypr/apps

# Copy the AppRun script to the Hypr config apps directory
cp "$tmp_dir/hypr-settings" ~/.config/hypr/apps/
if [ $? -eq 0 ]; then
    echo ":: hypr-settings copied to ~/.config/hypr/apps/"
else
    echo "Error: Failed to copy hypr-settings to ~/.config/hypr/apps/"
    rm -rf "$tmp_dir"
    exit 1
fi

# Ensure AppRun is executable
chmod +x ~/.config/hypr/apps/hypr-settings
if [ $? -eq 0 ]; then
    echo ":: hypr-settings script is now executable"
else
    echo "Error: Failed to make hypr-settings executable"
    rm -rf "$tmp_dir"
    exit 1
fi

# Clean up temporary directory
rm -rf "$tmp_dir"

echo "Build process completed successfully."
