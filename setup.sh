#!/bin/bash
set -e

REPO_DIR="/home/miguelpinto/Desktop/home-server"
LOG_DIR="$REPO_DIR/logs"
SCRIPT_DIR="$REPO_DIR/scripts"
UPDATE_SCRIPT="$SCRIPT_DIR/update.sh"

# -----------------------------
# Clone or update repository
# -----------------------------
clone_repo() {
    echo "===== Checking repository ====="
    if [ ! -d "$REPO_DIR/.git" ]; then
        echo "Cloning repository to $REPO_DIR ..."
        git clone https://github.com/brunomiguelpinto/home-server.git "$REPO_DIR"
    else
        echo "Repository exists — pulling updates..."
        cd "$REPO_DIR"
        git pull
    fi
}

# -----------------------------
# Function: Install Docker
# -----------------------------
install_docker() {
    echo "===== Checking Docker installation ====="
    if command -v docker >/dev/null 2>&1; then
        echo "Docker is already installed."
    else
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com | sudo sh
        sudo usermod -aG docker $USER
    fi
}

# -----------------------------
# Function: Install Vim if needed
# -----------------------------
check_vim() {
    echo "===== Checking Vim installation ====="
    if command -v vim >/dev/null 2>&1; then
        echo "Vim is already installed."
    else
        echo "Installing Vim..."
        sudo apt-get install -y vim
    fi
}

# -----------------------------
# Function: Create required folders
# -----------------------------
create_folders() {
    echo "===== Creating required folders ====="
    mkdir -p "$LOG_DIR"
}

# -----------------------------
# Function: Add update script to crontab
# -----------------------------
setup_cron() {
    echo "===== Configuring crontab for update.sh ====="

    CRON_JOB="0 3 * * * $UPDATE_SCRIPT >> $LOG_DIR/update.log 2>&1"

    # Add cron entry if not already present
    (crontab -l 2>/dev/null | grep -F "$CRON_JOB") || \
    ( crontab -l 2>/dev/null; echo "$CRON_JOB" ) | crontab -

    echo "Cronjob installed:"
    echo "$CRON_JOB"
}

# -----------------------------
# Function: Update base system
# -----------------------------
system_update() {
    echo "===== Updating system ====="
    sudo apt-get update -y
    sudo apt-get full-upgrade -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y
}

# -----------------------------
# MAIN EXECUTION FLOW
# -----------------------------
clear
echo "===== Starting setup.sh ====="

system_update
clone_repo
create_folders
setup_cron
check_vim
install_docker

echo "===== DONE! ====="
echo "Reboot recommended: sudo reboot"