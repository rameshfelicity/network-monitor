#!/bin/bash

# Define GitHub repository URL and the script URL
GITHUB_REPO_URL="https://github.com/rameshfelicity/network-monitor/blob/main/setup_from_github.sh"
SCRIPT_PATH="$HOME/network_monitor.sh"

# Download the script from GitHub
curl -L "$GITHUB_REPO_URL" -o "$SCRIPT_PATH"

# Make the downloaded script executable
chmod +x "$SCRIPT_PATH"

# Run the script
"$SCRIPT_PATH"

# Output success message
echo "Script downloaded and executed successfully."
