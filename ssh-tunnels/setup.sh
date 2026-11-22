#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y openssh-server openssh-client socat curl python3 iproute2 procps
mkdir -p /root && cd /root
useradd -m -s /bin/bash deploy && mkdir -p /run/sshd && /usr/sbin/sshd
ssh-keygen -q -t ed25519 -f ~/.ssh/id_ed25519 -N "" && install -d -m 700 -o deploy -g deploy /home/deploy/.ssh && install -m 600 -o deploy -g deploy ~/.ssh/id_ed25519.pub /home/deploy/.ssh/authorized_keys
ssh -q -o StrictHostKeyChecking=accept-new deploy@localhost true
(setsid socat TCP-LISTEN:5432,bind=127.0.0.1,fork SYSTEM:'echo "db: hello from port 5432"' >/dev/null 2>&1 &); sleep 1
mkdir -p /tmp/site && echo "preview of my local app" > /tmp/site/index.html && (setsid python3 -m http.server 8000 --bind 127.0.0.1 --directory /tmp/site >/dev/null 2>&1 &); sleep 1
