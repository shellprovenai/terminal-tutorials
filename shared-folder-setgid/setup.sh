#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /srv && cd /srv
groupadd web && useradd -m -s /bin/bash -G web alice && useradd -m -s /bin/bash -G web bob && mkdir -p /srv/site
