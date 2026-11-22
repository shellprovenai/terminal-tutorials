#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y systemd systemd-sysv dbus
mkdir -p /root && cd /root
printf '#!/bin/sh\necho "hello-app starting"\nwhile true; do echo "tick $(date +%%T)"; sleep 2; done\n' > /usr/local/bin/hello-app && chmod +x /usr/local/bin/hello-app
printf '[Unit]\nDescription=Hello demo app\n\n[Service]\nExecStart=/usr/local/bin/hello-app\n\n[Install]\nWantedBy=multi-user.target\n' > /etc/systemd/system/hello-app.service
printf '[Unit]\nDescription=Report job (broken on purpose)\n\n[Service]\nType=oneshot\nExecStart=/usr/local/bin/report-tool\n' > /etc/systemd/system/report.service
systemctl daemon-reload
