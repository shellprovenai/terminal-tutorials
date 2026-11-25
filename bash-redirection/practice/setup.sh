#!/bin/sh
# setup.sh — builds /work: nightly.sh (a simulated backup script that prints progress on stdout and errors on stderr)
# and logs/nightly.log with the lines of an older run.
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
mkdir -p "$W"
rm -rf "$W/nightly.sh" "$W/logs" "$W/error-count.txt"
mkdir -p "$W/logs"
printf '#!/bin/sh\n# nightly.sh - copies a few folders (simulated) and reports what happened\necho "backup /etc: ok"\necho "backup /home: ok"\necho "ERROR: /var/www: permission denied" >&2\necho "backup /srv/git: ok"\necho "ERROR: /srv/media: no such file or directory" >&2\necho "finished with 2 errors"\nexit 1\n' > "$W/nightly.sh"
chmod 755 "$W/nightly.sh"
printf '=== run of 2026-11-23 ===\nbackup /etc: ok\nbackup /home: ok\n=== run of 2026-11-24 ===\nbackup /etc: ok\n' > "$W/logs/nightly.log"
echo
cat /practice/TASK.md 2>/dev/null || true
