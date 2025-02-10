#!/bin/bash

# GitHub credentials for private repo access
GITHUB_USERNAME="your-username"
GITHUB_TOKEN="your-personal-access-token"
GITHUB_REPO="your-username/network-monitor"
FILE_PATH="network_monitor.sh"

# Define script path
SCRIPT_PATH="$HOME/network_monitor.sh"
CRON_CMD="* * * * * $HOME/network_monitor.sh"

# Attempt to download the script from the private GitHub repository
echo "Attempting to download network_monitor.sh from GitHub..."
curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" -L -o "$SCRIPT_PATH" \
     "https://raw.githubusercontent.com/$GITHUB_REPO/main/$FILE_PATH"

# If download fails, create the script manually as a fallback
if [ $? -ne 0 ]; then
    echo "Failed to download from GitHub. Creating script manually..."
    
    cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash

# Get the home directory dynamically
USER_HOME="$HOME"

# Define directories
CONNECTIVITY_DIR="$USER_HOME/connectivity"
LOGFILE="$CONNECTIVITY_DIR/logfile"
BACKUP_DIR="$CONNECTIVITY_DIR/backups"
DATE=$(date +'%Y-%m-%d')

# Ensure the 'connectivity' directory and its subdirectories exist
if [ ! -d "$CONNECTIVITY_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "Created directory: $CONNECTIVITY_DIR"
fi

# Check connectivity and log results
ping -c 1 8.8.8.8 || echo "$(date): No connectivity" >> "$LOGFILE"

# Backup process (runs only on Sundays)
if [[ $(date +%u) -eq 7 ]]; then
    cp "$LOGFILE" "$BACKUP_DIR/logfile_$DATE"

    # Keep only the last 4 backups
    ls -t "$BACKUP_DIR"/logfile_* | tail -n +5 | xargs rm -f
fi
EOF

    echo "Fallback script created at $SCRIPT_PATH."
else
    echo "Downloaded script successfully."
fi

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Update the crontab to run the script every minute
(crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH"; echo "$CRON_CMD") | crontab -

# Run the script
"$SCRIPT_PATH"

# Output success message
echo "Script setup complete. Crontab updated."
