#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y procps
mkdir -p /lab/proc && cd /lab/proc
printf '#!/bin/sh\nwhile :; do :; done\n' > /usr/local/bin/busy && chmod +x /usr/local/bin/busy
printf '#!/bin/bash\ntrap "echo cleaning up; rm -f /tmp/worker.lock; exit 0" TERM\ntouch /tmp/worker.lock\nwhile :; do sleep 1; done\n' > worker.sh && chmod +x worker.sh
(setsid busy >/dev/null 2>&1 &); (setsid ./worker.sh > worker.log 2>&1 &); sleep 2
