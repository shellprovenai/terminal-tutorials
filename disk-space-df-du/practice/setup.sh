#!/bin/sh
# setup.sh — builds the practice folder /work/var (a small server with logs, cache, mail and a website) and starts a
# program that keeps writing to /work/var/log/app/app.log. Meant to run inside the throwaway container from start.sh.
# Only touches /work.
set -e
W=${WORK:-/work}
# stop the log writer from an earlier run, if any
for fd in $(find /proc/[0-9]*/fd -lname "$W/var/log/app/app.log*" 2>/dev/null); do
  p=${fd#/proc/}; kill "${p%%/*}" 2>/dev/null || true
done
rm -rf "$W/var" "$W/usage.txt"
mkdir -p "$W/var/log/app" "$W/var/log/nginx" "$W/var/cache/thumbs" "$W/var/mail" "$W/var/www/img"
cd "$W/var"
fallocate -l 70M log/app/app.log
fallocate -l 40M log/app/app.log.1
fallocate -l 10M log/nginx/access.log
fallocate -l 40M cache/thumbs/thumbs.db
fallocate -l 16M mail/anna.mbox
fallocate -l 8M mail/tom.mbox
fallocate -l 6M www/img/banner.png
fallocate -l 2M www/index.html
# the "app": keeps app.log open and adds a line every 30 seconds
setsid sh -c 'while sleep 30; do echo "$(date) app: heartbeat"; done' >> log/app/app.log 2>&1 < /dev/null &
echo
cat /practice/TASK.md 2>/dev/null || true
