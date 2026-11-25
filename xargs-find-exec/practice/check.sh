#!/bin/sh
# check.sh — checks the lesson 17 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
P="$W/project"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

if [ ! -d "$P" ]; then
  echo "FAIL  /work/project is missing — run sh /practice/setup.sh to start over"
  echo; echo "RESULT: FAIL (1 check(s) failed)"; exit 1
fi

# Rule: the real files stay
missing=""
for f in report.txt config.ini notes/draft src/main.c logs/README.txt; do
  [ -f "$P/$f" ] || missing="$missing $f"
done
if [ -z "$missing" ]; then pass "report.txt, config.ini, notes/draft, src/main.c and logs/README.txt are still there"
elif echo "$missing" | grep -q "notes/draft"; then
  fail "notes/draft was deleted — plain xargs split \"notes/draft v2.bak\" at the space; use find -print0 | xargs -0"
else fail "files that are not .bak were deleted:$missing — run sh /practice/setup.sh to start over"
fi
if [ -f "$P/notes/draft" ] && ! grep -qx "keep me: first draft of the notes" "$P/notes/draft"; then
  fail "notes/draft was changed"
fi

# Part 1: no .bak files left
left=$(cd "$P" && find . -name '*.bak' | sort | tr '\n' ',' | sed 's/,$//; s/,/, /g')
if [ -z "$left" ]; then pass "all four .bak files are gone"
elif [ ! -f "$P/config.bak" ] && echo "$left" | grep -q 'old report\.bak\|draft v2\.bak'; then
  fail "still there: $left — names with a space were split by xargs; use find -print0 | xargs -0"
else fail "these .bak files are still there: $left"
fi

# Part 2: every log compressed separately, content intact
ok=1
for n in "web 1" "web 2" api "db errors"; do
  if [ -f "$P/logs/$n.log" ] && [ -f "$P/logs/api.log.gz" ]; then
    ok=0; fail "logs/$n.log is not compressed — xargs split the name at the space; use -print0 | xargs -0"
  elif [ -f "$P/logs/$n.log" ]; then
    ok=0; fail "logs/$n.log is not compressed yet"
  elif [ ! -f "$P/logs/$n.log.gz" ]; then
    ok=0; fail "logs/$n.log.gz is missing"
  elif [ "$(zcat "$P/logs/$n.log.gz" 2>/dev/null | md5sum)" != "$(seq 1 2000 | sed "s/^/$n: request /" | md5sum)" ]; then
    ok=0; fail "logs/$n.log.gz does not hold the original log"
  fi
done
extra=$(cd "$P/logs" && ls | grep -v -x -e 'web 1.log.gz' -e 'web 2.log.gz' -e 'api.log.gz' -e 'db errors.log.gz' -e README.txt | grep -v '\.log$' | tr '\n' ' ')
if [ -n "$extra" ]; then ok=0; fail "unexpected files in logs: $extra(one .gz per log, README.txt untouched)"; fi
if [ -f "$P/logs/README.txt" ] && ! grep -qx "Logs are rotated every night." "$P/logs/README.txt"; then
  ok=0; fail "logs/README.txt was changed"
fi
[ $ok -eq 1 ] && pass "each log is now its own .log.gz with the original content"

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
