#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/work && cd /lab/work
mkdir -p project/src project/node_modules/lib project/logs
printf 'print("hello")\n' > project/src/app.py && printf 'debug = false\n' > project/src/config.ini && printf '# Demo project\n' > project/README.md
head -c 6M /dev/urandom > project/node_modules/lib/bundle.bin && head -c 2M /dev/urandom > project/logs/app.log
