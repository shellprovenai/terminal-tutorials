#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/srv && cd /lab/srv
mkdir -p app/logs app/cache/thumbs backups uploads
fallocate -l 60M app/logs/app.log.1 && fallocate -l 8M app/logs/app.log && fallocate -l 24M app/cache/thumbs/blob.bin
fallocate -l 100M backups/db-2026-10.sql.gz && fallocate -l 104M backups/db-2026-11.sql.gz && fallocate -l 3M uploads/photo.jpg
