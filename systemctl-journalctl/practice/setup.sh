#!/bin/sh
# setup.sh — builds the practice in /work: a real (binary) systemd journal copied from server "web1" with two boots
# (/work/journal), and the disk of that server with its unit files (/work/rootfs).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/journal" "$W/rootfs" "$W/missing.txt" "$W/.export"
mkdir -p "$W/journal"

# --- the journal: entries in the journal export format, converted by systemd-journal-remote
B1=3f1c9a7e52d84b6e9a0c1d2e3f405162   # previous boot (yesterday)
B2=8d2e4f6a1b3c4d5e8f9a0b1c2d3e4f50   # last boot (today)
now=$(date +%s)
ent() {   # ent SECONDS_AGO BOOT PRIORITY IDENT PID UNIT MESSAGE   (UNIT for systemd's own lines, _SYSTEMD_UNIT for services)
  t=$(( (now - $1) * 1000000 ))
  printf '__REALTIME_TIMESTAMP=%s\n__MONOTONIC_TIMESTAMP=%s\n_BOOT_ID=%s\n_HOSTNAME=web1\nPRIORITY=%s\nSYSLOG_IDENTIFIER=%s\n_PID=%s\n' \
    "$t" "$t" "$2" "$3" "$4" "$5"
  if [ "$5" = 1 ]; then printf '_COMM=systemd\nUNIT=%s\n_SYSTEMD_UNIT=init.scope\n' "$6"; else printf '_SYSTEMD_UNIT=%s\n' "$6"; fi
  printf 'MESSAGE=%s\n\n' "$7"
}
{
  ent 93600 $B1 6 systemd 1 nginx.service "Started nginx.service - A high performance web server."
  ent 93590 $B1 6 nginx 412 nginx.service "nginx: server ready on port 80"
  ent 93000 $B1 6 systemd 1 backup.service "Starting backup.service - Nightly backup..."
  ent 93000 $B1 3 "(run.sh)" 530 backup.service "backup.service: Unable to locate executable '/opt/backup/run.sh': No such file or directory"
  ent 93000 $B1 3 "(run.sh)" 530 backup.service "backup.service: Failed at step EXEC spawning /opt/backup/run.sh: No such file or directory"
  ent 93000 $B1 3 systemd 1 backup.service "Failed to start backup.service - Nightly backup."
  ent 92000 $B1 6 CRON 601 cron.service "(root) CMD (/usr/local/sbin/rotate-logs)"
  ent 10800 $B2 6 systemd 1 nginx.service "Started nginx.service - A high performance web server."
  ent 10790 $B2 6 nginx 388 nginx.service "nginx: server ready on port 80"
  ent 10200 $B2 6 systemd 1 backup.service "Starting backup.service - Nightly backup..."
  ent 10200 $B2 3 "(kup-run)" 455 backup.service "backup.service: Unable to locate executable '/usr/local/bin/backup-run': No such file or directory"
  ent 10200 $B2 3 "(kup-run)" 455 backup.service "backup.service: Failed at step EXEC spawning /usr/local/bin/backup-run: No such file or directory"
  ent 10200 $B2 3 systemd 1 backup.service "Failed to start backup.service - Nightly backup."
  ent 9000 $B2 6 CRON 640 cron.service "(root) CMD (/usr/local/sbin/rotate-logs)"
  ent 3600 $B2 4 nginx 388 nginx.service "nginx: 3 slow requests in the last hour"
} > "$W/.export"
/lib/systemd/systemd-journal-remote -o "$W/journal/web1.journal" "$W/.export" 2>/dev/null
rm -f "$W/.export"

# --- the server's disk
R="$W/rootfs"
mkdir -p "$R/etc/systemd/system/multi-user.target.wants" "$R/usr/lib/systemd/system" "$R/usr/local/sbin" "$R/opt"
printf '[Unit]\nDescription=Multi-User System\nRequires=basic.target\nAfter=basic.target\n' > "$R/usr/lib/systemd/system/multi-user.target"
printf '[Unit]\nDescription=A high performance web server\n\n[Service]\nExecStart=/usr/sbin/nginx -g "daemon off;"\n\n[Install]\nWantedBy=multi-user.target\n' \
  > "$R/usr/lib/systemd/system/nginx.service"
ln -s /usr/lib/systemd/system/nginx.service "$R/etc/systemd/system/multi-user.target.wants/nginx.service"
printf '#!/bin/sh\n# nightly backup of /var/www\ntar -czf /var/backups/www-$(date +%%F).tgz /var/www\n' > "$R/usr/local/sbin/backup-run"
chmod +x "$R/usr/local/sbin/backup-run"
printf '[Unit]\nDescription=Nightly backup\n\n[Service]\nType=oneshot\nExecStart=/usr/local/bin/backup-run\n\n[Install]\nWantedBy=multi-user.target\n' \
  > "$R/etc/systemd/system/backup.service"
echo
cat /practice/TASK.md 2>/dev/null || true
