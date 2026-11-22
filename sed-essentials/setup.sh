#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/sed && cd /lab/sed
printf '# app settings\nhost=localhost\nport=8080\nadmin_port=8080\n\n# links\nurl=http://localhost:8080/health?port=8080#start\ndebug=true\n' > app.conf
for i in $(seq 1 30); do echo "2026-11-20 10:00:$i INFO request $i"; done > app.log && sed -i '12s/INFO/ERROR/; 21s/INFO/ERROR/' app.log
sed -i '15i --- START deploy' app.log && sed -i '18i --- END deploy' app.log
