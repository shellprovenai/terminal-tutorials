#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/files && cd /lab/files
mkdir -p logs && printf 'one\ntwo\n' > "My Report.txt" && printf 'a\nb\nc\n' > notes.txt && printf 'x\n' > "Q3 plan.txt"
for i in 1 2 3 4; do seq 1000 > "logs/app $i.log"; done && touch old1.tmp "old 2.tmp"
