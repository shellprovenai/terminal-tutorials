#!/bin/sh
# setup.sh — builds the practice folder /work (a nightly database dump job that works by hand but not from cron).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/bin" "$W/jobs" "$W/logs" "$W/dump.cron"
mkdir -p "$W/bin" "$W/jobs" "$W/logs"
# the team's tool, in /work/bin (on the team's login PATH, not on cron's)
cat > "$W/bin/dumptool" <<'EOF'
#!/bin/sh
echo "warning: table sessions skipped" >&2
printf 'CREATE TABLE orders (id INT, total REAL);\nINSERT INTO orders VALUES (1, 19.90);\nINSERT INTO orders VALUES (2, 5.00);\n'
EOF
cat > "$W/jobs/dump.sh" <<'EOF'
#!/bin/sh
dumptool shop > dump.sql
echo "dump done: $(wc -l < dump.sql) lines"
EOF
chmod +x "$W/bin/dumptool" "$W/jobs/dump.sh"
echo
cat /practice/TASK.md 2>/dev/null || true
