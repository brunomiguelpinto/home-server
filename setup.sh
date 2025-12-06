#!/bin/bash

# Check if Vim is installed and install if not
check_vim() {
    if [ -x "$(command -v vim)" ]; then
        echo "Vim is already installed."
    else
        echo "Installing Vim..."
        sudo apt-get install -y vim
    fi
}


mkdir -p /home/miguelpinto/Desktop/home-server/logs
echo "===== Adding update.sh to crontab ====="

CRON_JOB="0 3 * * * /home/miguelpinto/Desktop/home-server/scripts/update.sh >> /home/miguelpinto/Desktop/home-server/logs/update.log 2>&1"

(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || \
( crontab -l 2>/dev/null; echo "$CRON_JOB" ) | crontab -

echo "===== DONE! ====="
echo "Reboot recommended: sudo reboot"

check_vim             # Install Vim if not installed
