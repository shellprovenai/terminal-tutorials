#!/bin/sh
# setup.sh — builds the practice folder /work (a web shop's request log, /work/app.log, and an empty /work/report).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/app.log" "$W/report"
mkdir -p "$W/report"
# columns: time, user, status, a message (any number of words), duration in ms (always the last word)
cat > "$W/app.log" <<'EOF'
08:59:58 anna 200 opened the dashboard 120
09:00:03 tom 200 logged in 45
09:00:15 tom 500 export of the monthly sales report failed 2300
09:01:02 mia 200 uploaded avatar.png 640
09:01:40 anna 404 asked for an old invoice 15
09:02:11 ben 200 search for blue shoes size 42 1180
09:02:30 mia 200 viewed orders 90
09:03:05 anna 200 downloaded the full yearly report as pdf 1450
09:03:44 tom 200 logged out 20
09:04:10 ben 200 added item to cart 75
09:04:52 mia 503 payment gateway timeout 5000
09:05:20 ben 200 checkout 310
EOF
echo
cat /practice/TASK.md 2>/dev/null || true
