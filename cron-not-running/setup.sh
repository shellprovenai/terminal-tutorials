#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
# needs: apt-get install -y cron
mkdir -p /lab/jobs && cd /lab/jobs
printf '#!/bin/sh\necho "report for $(hostname): 42 orders"\n' > /usr/local/bin/report-tool && chmod +x /usr/local/bin/report-tool
printf '#!/bin/sh\nreport-tool > report.txt\necho "saved report"\n' > backup.sh && chmod +x backup.sh && cron
printf '# min hour day month weekday  command\n* * * * * /lab/jobs/backup.sh >> /tmp/backup.log 2>&1\n* * * * * env > /tmp/cron-env.txt\n' > first.cron
for i in $(seq 90); do [ -s /tmp/cron-env.txt ] && break; sleep 2; done; sleep 2
printf 'PATH=/usr/local/bin:/usr/bin:/bin\n# min hour day month weekday  command\n* * * * * cd /lab/jobs && ./backup.sh >> /tmp/backup.log 2>&1\n* * * * * echo "ran at $(date +%%H:%%M)" >> /tmp/broken.log\n* * * * * echo "ran at $(date +\\%%H:\\%%M)" >> /tmp/fixed.log\n' > fixed.cron
for i in $(seq 90); do [ -s /tmp/fixed.log ] && break; sleep 2; done; sleep 2
