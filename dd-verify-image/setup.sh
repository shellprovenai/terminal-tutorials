#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y pv
mkdir -p /lab/usb && cd /lab/usb
head -c 48M /dev/urandom > distro.iso && sha256sum distro.iso > SHA256SUMS
