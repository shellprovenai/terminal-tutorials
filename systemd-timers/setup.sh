#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y systemd systemd-sysv dbus
mkdir -p /root && cd /root
printf '#!/bin/sh\necho "report generated at $(date +%%T)" >> /var/log/report.log\necho "report OK"\n' > /usr/local/bin/make-report && chmod +x /usr/local/bin/make-report
printf '[Unit]\nDescription=Generate the report\n\n[Service]\nType=oneshot\nExecStart=/usr/local/bin/make-report\n' > /etc/systemd/system/report.service
printf '[Unit]\nDescription=Run the report every 10 seconds (demo)\n\n[Timer]\nOnCalendar=*:*:0/10\nAccuracySec=1s\nPersistent=true\n\n[Install]\nWantedBy=timers.target\n' > /etc/systemd/system/report.timer
systemctl daemon-reload
