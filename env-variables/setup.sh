#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y sudo
mkdir -p /lab/env && cd /lab/env
printf 'DB_HOST=db.local\nDB_PORT=5432\n' > app.env
