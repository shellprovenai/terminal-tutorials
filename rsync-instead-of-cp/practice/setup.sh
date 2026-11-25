#!/bin/sh
# setup.sh — builds /work/docs (a team's documents) and /work/mirror (a copy of it from last week).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/docs" "$W/mirror" "$W/preview.txt"
mkdir -p "$W/docs/drafts" "$W/docs/reports"
cd "$W/docs"
printf 'Team notes\n' > notes.md
printf 'Plan for Q3\n' > old-plan.md
printf 'scratch\n' > drafts/scratch.md
printf 'Intro draft\n' > drafts/intro.md
head -c 200K /dev/urandom > reports/report.pdf
find . -exec touch -d '2026-11-01 09:00' {} +
# last week's copy, made the right way
rsync -a "$W/docs/" "$W/mirror/"
# what happened since then
printf 'Meeting on Monday\n' >> notes.md
printf 'item,cost\nlaptop,900\n' > budget.csv
rm old-plan.md drafts/scratch.md
printf 'swap\n' > .notes.md.swp
mkdir -p .cache && head -c 50K /dev/urandom > .cache/index.db
touch -d '2026-11-20 15:00' notes.md budget.csv .notes.md.swp .cache/index.db
echo
cat /practice/TASK.md 2>/dev/null || true
