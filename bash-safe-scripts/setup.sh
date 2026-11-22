#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y shellcheck
mkdir -p /lab/scripts && cd /lab/scripts
mkdir -p /lab/scripts/build && touch /lab/scripts/build/old.o
printf '#!/bin/bash\ncd /lab/scripts/biuld\necho "cleaning in: $(pwd)"\n' > clean.sh
printf '#!/bin/bash\nset -e\ncd /lab/scripts/biuld\necho "cleaning in: $(pwd)"\n' > clean-safe.sh
touch "my notes.txt" draft.txt
