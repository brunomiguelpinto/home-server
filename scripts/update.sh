#!/bin/bash
set -e

LOG_FILE="/home/miguelpinto/Desktop/home-server/logs/update.log"

echo "===== Update started at $(date) =====" | tee -a "$LOG_FILE"

echo "Updating package list..." | tee -a "$LOG_FILE"
sudo apt-get update -y | tee -a "$LOG_FILE"

echo "Upgrading packages..." | tee -a "$LOG_FILE"
sudo apt-get full-upgrade -y | tee -a "$LOG_FILE"

echo "Removing unnecessary packages..." | tee -a "$LOG_FILE"
sudo apt-get autoremove -y | tee -a "$LOG_FILE"

echo "Cleaning package cache..." | tee -a "$LOG_FILE"
sudo apt-get autoclean -y | tee -a "$LOG_FILE"

# -----------------------------
# Docker Update Section
# -----------------------------
echo "Checking for Docker updates..." | tee -a "$LOG_FILE"
sudo apt-get install --only-upgrade docker-ce docker-ce-cli containerd.io -y | tee -a "$LOG_FILE" || \
echo "Docker update skipped (not installed through apt)." | tee -a "$LOG_FILE"

# -----------------------------
# Docker Compose Plugin Update
# -----------------------------
echo "Checking for Docker Compose Plugin updates..." | tee -a "$LOG_FILE"
sudo apt-get install --only-upgrade docker-compose-plugin -y | tee -a "$LOG_FILE" || \
echo "Docker Compose Plugin update skipped (not installed)." | tee -a "$LOG_FILE"

# -----------------------------
# Optional: Clean old Docker images
# -----------------------------
echo "Cleaning unused Docker data..." | tee -a "$LOG_FILE"
docker system prune -af 2>> "$LOG_FILE" | tee -a "$LOG_FILE" || \
echo "Docker prune skipped (Docker not installed)." | tee -a "$LOG_FILE"

echo "===== Update completed at $(date) =====" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"