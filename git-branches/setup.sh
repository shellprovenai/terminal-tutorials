#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y git
mkdir -p /lab/repo && cd /lab/repo
git init -q -b main && git config user.name Demo && git config user.email demo@example.com && git config --global color.ui false
echo "v1" > app.txt && git add . && git commit -qm "First version"
