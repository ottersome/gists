#!/usr/bin/env sh
if pidof -o %PPID -x “rclone-cron.sh”; then
exit 1
fi
rclone sync /home/ottersome/Thesis digitalocean:laptop/Thesis
rclone sync /home/ottersome/projects digitalocean:laptop/projects
exit
