#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it localhost/shellproven-ssh-keys:13 bash
set -euo pipefail
# needs: apt-get install -y openssh-server openssh-client
mkdir -p /lab && cd /lab
useradd -m -s /bin/bash deploy && mkdir -p /run/sshd && /usr/sbin/sshd
