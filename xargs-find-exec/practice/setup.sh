#!/bin/sh
# setup.sh — builds the practice folder /work/project (a small project with backup files and logs, some names with spaces).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/project"
mkdir -p "$W/project/notes" "$W/project/src" "$W/project/logs"
cd "$W/project"
echo "Quarterly report" > report.txt
echo "old copy" > "old report.bak"
echo "port = 8080" > config.ini
echo "port = 80" > config.bak
echo "keep me: first draft of the notes" > notes/draft
echo "old draft" > "notes/draft v2.bak"
echo "int main(void) { return 0; }" > src/main.c
echo "int main(void) { return 1; }" > src/main.c.bak
for n in "web 1" "web 2" api "db errors"; do
  seq 1 2000 | sed "s/^/$n: request /" > "logs/$n.log"
done
echo "Logs are rotated every night." > logs/README.txt
echo
cat /practice/TASK.md 2>/dev/null || true
