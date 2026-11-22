#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /root && cd /root
useradd -m -s /bin/bash demo
sed -i '1i echo "-> reading ~/.bashrc"' /home/demo/.bashrc && sed -i '1i echo "-> reading ~/.profile"' /home/demo/.profile
echo "alias deploy='echo deploying the app'" >> /home/demo/.bashrc
