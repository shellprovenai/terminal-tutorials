#!/bin/sh
# check.sh — checks the lesson 07 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
V="$W/var"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
LOG="$V/log/app/app.log"

# Part 1: folders sorted by size (smallest first): www 8M, mail 24M, cache 40M, log 120M
want="www mail cache log"
if [ ! -s "$W/usage.txt" ]; then
  fail "/work/usage.txt does not exist yet (or is empty)"
else
  got=$(awk -F'\t' 'NF >= 2 { n = $NF; sub(/\/$/, "", n); sub(/.*\//, "", n); if (n != "." && n != "var" && n != "") print n }' "$W/usage.txt" | tr '\n' ' ' | sed 's/ $//')
  if [ "$got" = "$want" ]; then
    if grep -Eq '^[0-9.]+[KMG]	' "$W/usage.txt"; then pass "usage.txt lists the folders from the smallest to the biggest"
    else fail "usage.txt has the right order, but the sizes are not human-readable (use du -h)"; fi
  elif [ "$got" = "log mail cache www" ]; then
    fail "usage.txt is sorted as text, so the 3-digit size comes first — plain sort doesn't understand sizes, try sort -h"
  elif [ "$got" = "log cache mail www" ]; then
    fail "usage.txt is sorted from the biggest — the task wants the smallest first"
  else
    fail "usage.txt has the wrong folders or order (found: $got; expected the 4 folders inside /work/var, one line each)"
  fi
fi

# Part 2: app.log emptied in place, the program still running, the space really freed
writer=""; deleted=""
for fd in $(find /proc/[0-9]*/fd 2>/dev/null -lname "$LOG*" 2>/dev/null); do
  l=$(readlink "$fd"); case "$l" in *"(deleted)") deleted=1 ;; *) writer=1 ;; esac
done
if [ -n "$deleted" ]; then
  fail "app.log was deleted while the program still has it open, so the space is NOT freed — run sh /practice/setup.sh to start over and empty the file with truncate -s 0 instead"
elif [ ! -f "$LOG" ]; then
  fail "app.log is gone — the file must stay in place (empty)"
elif [ -z "$writer" ]; then
  fail "the program that writes app.log is no longer running — don't stop it, just empty the file"
elif [ "$(du -k "$LOG" | cut -f1)" -gt 1024 ]; then
  fail "app.log still uses $(du -h "$LOG" | cut -f1) — empty it"
else pass "app.log is empty, still in place, and the program keeps writing to it"
fi

# Rule: nothing else deleted or changed
ok=1
for f in log/app/app.log.1:40 log/nginx/access.log:10 cache/thumbs/thumbs.db:40 mail/anna.mbox:16 mail/tom.mbox:8 www/img/banner.png:6 www/index.html:2; do
  p=${f%:*}; mb=${f##*:}
  [ "$(stat -c %s "$V/$p" 2>/dev/null)" = "$((mb * 1048576))" ] || { ok=0; echo "      changed or missing: $p"; }
done
[ $ok -eq 1 ] && pass "all the other files are untouched" || fail "other files were deleted or changed — only app.log may be emptied (run sh /practice/setup.sh to start over)"

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
