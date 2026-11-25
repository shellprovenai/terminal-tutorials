#!/bin/sh
# check.sh — checks the lesson 01 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
clean() { sed -e 's|^\./||' -e 's|^site/||' -e 's|^\./||' | grep -v '/$' | sort; }   # accept ./x, site/x or x

[ "$(find "$W/site" -type f | wc -l)" -eq 10 ] && [ -f "$W/site/cache/page1.html" ] \
  && pass "/work/site still has its 10 files" || fail "files in /work/site were removed or added — run sh /practice/setup.sh to start over"

want24=$(cd "$W/site" && find . -path ./cache -prune -o -type f -mmin -1440 -print | clean)
if [ ! -f "$W/changed.tgz" ]; then
  fail "/work/changed.tgz does not exist yet"
else
  got=$(tar -tzf "$W/changed.tgz" 2>/dev/null | clean)
  if [ "$got" = "$want24" ]; then pass "changed.tgz has exactly the files from the last 24 hours (cache skipped)"
  else
    fail "changed.tgz has the wrong files"
    echo "      expected: $(echo "$want24" | tr '\n' ' ')"
    echo "      found:    $(echo "$got" | tr '\n' ' ')"
  fi
fi

want72=$(cd "$W/site" && find . -type f -mmin +4320 | clean)
if [ ! -f "$W/old.txt" ]; then
  fail "/work/old.txt does not exist yet"
else
  got=$(clean < "$W/old.txt" | grep -v '^$')
  if [ "$got" = "$want72" ]; then pass "old.txt lists exactly the files older than 72 hours"
  elif echo "$want72" | grep -q logo.png && ! echo "$got" | grep -q logo.png; then
    fail "old.txt misses a file that is 80 hours old — how does -mtime round days?"
  else fail "old.txt has the wrong files ($(echo "$got" | tr '\n' ' '))"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
