#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y git ca-certificates
mkdir -p /lab/shop && cd /lab/shop
git init -q -b main && git config user.name Demo && git config user.email demo@example.com && git config --global color.ui false
echo "price = 10" > app.conf && git add . && git commit -qm "Add config"
echo "currency = EUR" >> app.conf && git commit -qam "Add currency"
echo "debug = true" >> app.conf && git commit -qam "Enable debug"
