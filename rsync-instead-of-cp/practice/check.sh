#!/bin/sh
# check.sh — checks the lesson 12 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
D="$W/docs"; M="$W/mirror"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

# Rule: /work/docs is unchanged
if [ "$(cd "$D" 2>/dev/null && find . -type f | sort | tr '\n' ' ')" = "./.cache/index.db ./.notes.md.swp ./budget.csv ./drafts/intro.md ./notes.md ./reports/report.pdf " ] \
   && grep -q "Meeting on Monday" "$D/notes.md"; then
  pass "/work/docs is unchanged"
else fail "files in /work/docs were changed, removed or added — run sh /practice/setup.sh to start over"
fi

# Part 1: the dry-run preview
if [ ! -s "$W/preview.txt" ]; then
  fail "/work/preview.txt does not exist yet (or is empty)"
elif grep -q 'docs/' "$W/preview.txt"; then
  fail "preview.txt shows paths like docs/notes.md — without the slash after docs, rsync copies the folder itself"
elif ! grep -q '^\*deleting  *old-plan\.md$' "$W/preview.txt" || ! grep -q '^\*deleting  *drafts/scratch\.md$' "$W/preview.txt"; then
  fail "preview.txt doesn't list both deleted files — did you add --delete (and -i) to the dry run? (if you already synced, run setup.sh again)"
elif grep -q -e '\.swp' -e '\.cache' "$W/preview.txt"; then
  fail "preview.txt still includes *.swp or .cache — add --exclude='*.swp' --exclude=.cache/"
elif ! grep -q 'notes\.md$' "$W/preview.txt" || ! grep -q 'budget\.csv$' "$W/preview.txt"; then
  fail "preview.txt should also show the changed notes.md and the new budget.csv — use -i"
else pass "preview.txt lists the changes, including the two deletions"
fi

# Part 2: the real sync
if [ -d "$M/docs" ]; then
  fail "/work/mirror/docs exists — put a slash after the source (docs/) to copy its contents; delete /work/mirror/docs"
elif [ "$(cd "$M" 2>/dev/null && find . -type f | sort | tr '\n' ' ')" != "./budget.csv ./drafts/intro.md ./notes.md ./reports/report.pdf " ]; then
  got=$(cd "$M" 2>/dev/null && find . -type f | sort | tr '\n' ' ')
  if echo "$got" | grep -q -e old-plan -e scratch; then fail "the mirror still has the deleted files old-plan.md and drafts/scratch.md — the real run needs --delete too"
  elif echo "$got" | grep -q -e '\.swp' -e '\.cache'; then fail "the mirror contains *.swp or .cache — exclude them"
  else fail "the mirror doesn't match docs yet (found: $got)"
  fi
elif ! diff -rq --exclude='*.swp' --exclude=.cache "$D" "$M" >/dev/null; then
  fail "some files in the mirror have different content than in docs"
elif [ "$(stat -c %Y "$D/notes.md")" != "$(stat -c %Y "$M/notes.md")" ] || [ "$(stat -c %Y "$D/reports/report.pdf")" != "$(stat -c %Y "$M/reports/report.pdf")" ]; then
  fail "the files match, but the modification times don't — use rsync -a (archive mode), not cp"
else pass "the mirror matches docs: same files and times, deletions done, no *.swp or .cache"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
