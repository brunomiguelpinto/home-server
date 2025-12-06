#!/bin/bash

echo "===== Adding update.sh to crontab ====="

CRON_JOB="0 3 * * * /home/miguelpinto/Desktop/home-server/scripts/update.sh >> /home/miguelpinto/Desktop/update.log 2>&1"

(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || \
( crontab -l 2>/dev/null; echo "$CRON_JOB" ) | crontab -

echo "===== DONE! ====="
echo "Reboot recommended: sudo reboot"
