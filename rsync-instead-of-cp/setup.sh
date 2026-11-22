#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y rsync
mkdir -p /lab/sync && cd /lab/sync
mkdir -p photos/2026 photos/cache && for f in a b c; do head -c 300K /dev/urandom > photos/2026/$f.jpg; done
printf 'Trip notes\n' > photos/notes.txt && head -c 100K /dev/urandom > photos/cache/thumbs.tmp && printf 'old\n' > photos/old.txt
