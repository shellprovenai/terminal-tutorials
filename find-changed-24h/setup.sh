#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/project && cd /lab/project
mkdir -p src logs node_modules/pkg
for f in src/app.py logs/app.log src/config.yaml src/utils.py README.md src/old_notes.txt LICENSE node_modules/pkg/index.js; do echo demo > "$f"; done
touch -d "10 minutes ago" src/app.py; touch -d "3 hours ago" logs/app.log; touch -d "20 hours ago" src/config.yaml
touch -d "30 hours ago" src/utils.py; touch -d "47 hours ago" README.md; touch -d "50 hours ago" src/old_notes.txt
touch -d "5 days ago" LICENSE; touch -d "1 hour ago" node_modules/pkg/index.js
