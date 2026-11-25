#!/bin/sh
# check.sh — checks the lesson 13 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
# give a process that just got SIGTERM a few seconds to finish its cleanup
for i in 1 2 3 4 5 6; do pgrep -x exporter >/dev/null || break; [ -f "$W/exporter.lock" ] || break; sleep 0.5; done

# Rule: thumbnail-cache keeps running
if pgrep -x thumbnail-cache >/dev/null; then pass "thumbnail-cache is still running"
else fail "thumbnail-cache was stopped too — a pattern like thumb matches it; use pgrep first, or pkill -x thumbnailer (run sh /practice/setup.sh to start over)"
fi

# Part 1: the culprit is named and stopped
name=$(cat "$W/culprit.txt" 2>/dev/null | tr -d ' \n')
if [ ! -f "$W/culprit.txt" ]; then
  fail "/work/culprit.txt does not exist yet — ps aux --sort=-%cpu shows the busiest process first"
elif [ "$name" != "thumbnailer" ] && [ "$(basename "$name")" != "thumbnailer" ]; then
  fail "culprit.txt says \"$name\" — that's not the process at the top of ps aux --sort=-%cpu"
elif pgrep -x thumbnailer >/dev/null; then
  fail "you found the culprit, but thumbnailer is still running — stop it with kill or pkill"
else pass "the culprit thumbnailer is named in culprit.txt and stopped"
fi

# Part 2: the exporter stopped with SIGTERM and cleaned up
if pgrep -x exporter >/dev/null; then
  fail "the exporter is still running"
elif [ -f "$W/exporter.lock" ] || ! tail -1 "$W/export.csv" 2>/dev/null | grep -qx END; then
  fail "the exporter is gone, but it left a stale lock and no END — kill -9 (SIGKILL) can't be caught; use plain kill (run sh /practice/setup.sh to start over)"
else pass "the exporter got SIGTERM, wrote END and removed its lock"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
