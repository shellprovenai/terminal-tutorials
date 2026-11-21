#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/site && cd /lab/site
useradd -m alice && useradd -m bob && groupadd web && usermod -aG web alice
echo hello > index.html && printf '#!/bin/sh\necho deployed\n' > deploy.sh && echo DB_PASSWORD=demo > secret.env
mkdir private && echo x > private/notes.txt && chown -R alice:web /lab/site
