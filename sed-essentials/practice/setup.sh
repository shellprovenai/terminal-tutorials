#!/bin/sh
# setup.sh — builds the practice files /work/server.conf (a config moving to a new host name) and /work/cron.log (a nightly job log).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
mkdir -p "$W"
cd "$W"
rm -f server.conf server.conf.bak cron.log backup.txt
printf '%s\n' \
  '# server settings' \
  'server_name=old.example.com' \
  'listen=443' \
  '# upstream' \
  'proxy=http://old.example.com:8080/api?next=http://old.example.com/login' \
  'motd=Welcome to old.example.com, server #1' \
  'theme_color=#336699' > server.conf
{
  for i in $(seq 1 12); do echo "02:00:$i INFO job $i done"; done
  echo "02:01:00 INFO backup skipped on staging"
  echo "=== BEGIN backup"
  echo "02:01:01 INFO dumping database"
  echo "02:01:07 WARN table sessions is large"
  echo "02:01:30 INFO copying to /mnt/backup"
  echo "=== END backup"
  for i in $(seq 13 25); do echo "02:02:$i INFO job $i done"; done
} > cron.log
echo
cat /practice/TASK.md 2>/dev/null || true
