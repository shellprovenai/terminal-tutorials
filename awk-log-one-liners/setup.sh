#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/logs && cd /lab/logs
printf '10.0.0.5 GET /index.html 200 5120 12\n10.0.0.7 GET /login 200 2048 30\n10.0.0.5 POST /login 302 512 45\n10.0.0.9 GET /admin 404 256 3\n10.0.0.7 GET /api/orders 500 128 950\n10.0.0.5 GET /missing.png 404 256 2\n10.0.0.9 GET /api/orders 200 8192 120\n10.0.0.7 GET /index.html 200 5120 10\n' > access.log
printf 'id,name,city\n1,Ana,Lisbon\n2,Tom,Leeds\n3,Mia,Graz\n' > users.csv
