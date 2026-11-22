#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y iproute2 lsof psmisc socat procps
mkdir -p /lab/net && cd /lab/net
(setsid socat TCP-LISTEN:8080,fork SYSTEM:'echo hello' >/dev/null 2>&1 &); sleep 1
