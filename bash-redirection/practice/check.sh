#!/bin/sh
# check.sh — checks the lesson 06 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
L="$W/logs/nightly.log"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

old="=== run of 2026-11-23 ===
backup /etc: ok
backup /home: ok
=== run of 2026-11-24 ===
backup /etc: ok"
new="backup /etc: ok
backup /home: ok
ERROR: /var/www: permission denied
backup /srv/git: ok
ERROR: /srv/media: no such file or directory
finished with 2 errors"

# Rule: nightly.sh unchanged
if [ "$(cksum < "$W/nightly.sh" 2>/dev/null)" = "2259358024 297" ]; then pass "nightly.sh is unchanged"
else fail "nightly.sh was changed — run sh /practice/setup.sh to start over"
fi

# Part 1: old lines kept, the whole new output appended once
if [ ! -f "$L" ]; then
  fail "logs/nightly.log is gone — run sh /practice/setup.sh to start over"
else
  got=$(cat "$L")
  if [ "$got" = "$old
$new" ]; then pass "nightly.log kept the old lines and got the full output (errors included) once"
  elif [ "$(head -5 "$L")" != "$old" ]; then
    fail "the old lines in nightly.log are gone — a single > overwrites the file; use >> to append (sh /practice/setup.sh starts over)"
  elif [ "$got" = "$old" ]; then
    fail "nothing was added to nightly.log yet"
  elif ! grep -q '^ERROR' "$L"; then
    fail "nightly.log has the normal output but no ERROR lines — they go to stderr. Put 2>&1 AFTER the file: >> file 2>&1"
  elif [ "$(grep -c '^finished' "$L")" -gt 1 ]; then
    fail "the output was added more than once — run sh /practice/setup.sh and run the script one time"
  else fail "nightly.log doesn't end with the script's output in the right order"
  fi
fi

# Part 2: the number of ERROR lines
if [ ! -f "$W/error-count.txt" ]; then
  fail "/work/error-count.txt does not exist yet"
else
  c=$(tr -d ' \n\r' < "$W/error-count.txt")
  if [ "$c" = 2 ]; then pass "error-count.txt says 2"
  elif [ "$c" = 0 ]; then fail "error-count.txt says 0 — a pipe only carries stdout, and the errors are on stderr. Add 2>&1 before the |"
  else fail "error-count.txt should hold just the number of ERROR: lines, it has: $c"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
