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

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Update the crontab to run the script every minute
(crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -

# Output success message
echo "The network_monitor.sh script has been created and crontab updated."
