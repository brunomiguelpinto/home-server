#!/bin/bash
set -e

LOG_FILE="/home/miguelpinto/Desktop/home-server/logs/update.log"

echo "===== Update started at $(date) =====" | tee -a "$LOG_FILE"

echo "Updating package list..."
sudo apt-get update -y | tee -a "$LOG_FILE"

echo "Upgrading packages..."
sudo apt-get full-upgrade -y | tee -a "$LOG_FILE"

echo "Removing unnecessary packages..."
sudo apt-get autoremove -y | tee -a "$LOG_FILE"

echo "Cleaning package cache..."
sudo apt-get autoclean -y | tee -a "$LOG_FILE"

echo "===== Update completed at $(date) =====" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"