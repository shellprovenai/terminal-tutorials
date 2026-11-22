#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y git
mkdir -p /lab/repo && cd /lab/repo
git init -q -b main && git config user.name Demo && git config user.email demo@example.com && git config --global color.ui false
mkdir -p logs build && echo "print('hi')" > app.py && echo "API_KEY=demo-secret-123" > .env && echo "started" > logs/app.log && echo "bin" > build/app.bin
git add . && git commit -qm "Initial commit" && git clone -q . /lab/teammate
