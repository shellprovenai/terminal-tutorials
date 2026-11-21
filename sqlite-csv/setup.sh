#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it localhost/shellproven-sqlite-csv:13 bash
set -euo pipefail
# needs: apt-get install -y sqlite3
mkdir -p /lab/data && cd /lab/data
printf 'date,region,product,amount\n2026-01-14,north,keyboard,49.90\n2026-01-20,south,monitor,189.00\n2026-02-03,north,mouse,9.50\n2026-02-11,west,monitor,179.00\n2026-02-27,south,keyboard,52.00\n2026-03-05,west,mouse,12.00\n2026-03-09,north,monitor,199.00\n2026-03-18,south,mouse,8.75\n2026-03-30,west,keyboard,47.50\n' > sales.csv
