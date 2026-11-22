#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/text && cd /lab/text
printf '10.0.0.5 GET /index.html 200\n10.0.0.7 GET /login 200\n10.0.0.5 POST /login 302\n10.0.0.9 GET /admin 404\n10.0.0.7 GET /api 500\n10.0.0.5 GET /missing 404\n10.0.0.9 GET /login 200\n10.0.0.5 GET /index.html 200\n' > access.log
printf 'id,city,amount\n1,Leeds,12\n2,lisbon,9\n3,Graz,120\n4,Leeds,30\n5,Lisbon,15\n6,graz,8\n' > orders.csv
