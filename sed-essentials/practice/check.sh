#!/bin/sh
# check.sh — checks the lesson 18 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

orig() {
  printf '%s\n' \
    '# server settings' \
    'server_name=old.example.com' \
    'listen=443' \
    '# upstream' \
    'proxy=http://old.example.com:8080/api?next=http://old.example.com/login' \
    'motd=Welcome to old.example.com, server #1' \
    'theme_color=#336699'
}
want_conf() {
  printf '%s\n' \
    'server_name=new.example.com' \
    'listen=443' \
    'proxy=http://new.example.com:8080/api?next=http://new.example.com/login' \
    'motd=Welcome to new.example.com, server #1' \
    'theme_color=#336699'
}
log() {
  for i in $(seq 1 12); do echo "02:00:$i INFO job $i done"; done
  echo "02:01:00 INFO backup skipped on staging"
  echo "=== BEGIN backup"
  echo "02:01:01 INFO dumping database"
  echo "02:01:07 WARN table sessions is large"
  echo "02:01:30 INFO copying to /mnt/backup"
  echo "=== END backup"
  for i in $(seq 13 25); do echo "02:02:$i INFO job $i done"; done
}

# Part 1: server.conf
C="$W/server.conf"
if [ ! -f "$C" ]; then
  fail "/work/server.conf is missing — run sh /practice/setup.sh to start over"
elif [ "$(cat "$C")" = "$(want_conf)" ]; then
  pass "server.conf has no comment lines and uses new.example.com everywhere"
elif [ "$(cat "$C")" = "$(orig)" ]; then
  fail "server.conf is not changed yet — without -i, sed only prints the result"
elif ! grep -q '^motd=' "$C" || ! grep -q '^theme_color=' "$C"; then
  fail "the motd or theme_color line is gone — /#/ matches a # anywhere in the line; use /^#/ (run sh /practice/setup.sh to start over)"
elif grep -q '^#' "$C"; then
  fail "server.conf still has lines that start with #"
elif grep -q 'old\.example\.com' "$C"; then
  fail "old.example.com is still in server.conf — s/// changes only the first match on a line; add g"
else
  fail "server.conf is not what was expected"
  echo "      found: $(tr '\n' '|' < "$C")"
fi

B="$W/server.conf.bak"
if [ ! -f "$B" ]; then
  fail "/work/server.conf.bak does not exist — use -i.bak (no space) to keep the original"
elif [ "$(cat "$B")" = "$(orig)" ]; then
  pass "server.conf.bak is the untouched original"
else
  fail "server.conf.bak is not the original — did you run sed -i.bak twice? The second run overwrites the backup; do both edits in one sed (join them with ;)"
fi

# Part 2: backup.txt
L="$W/cron.log"
if [ "$(cat "$L" 2>/dev/null)" = "$(log)" ]; then pass "cron.log is unchanged"
else fail "cron.log was changed — run sh /practice/setup.sh to start over"
fi
want2=$(log | sed -n '/^=== BEGIN/,/^=== END/p')
if [ ! -f "$W/backup.txt" ]; then
  fail "/work/backup.txt does not exist yet"
else
  got=$(cat "$W/backup.txt")
  n=$(grep -c . "$W/backup.txt")
  if [ "$got" = "$want2" ]; then pass "backup.txt has exactly the backup section, markers included"
  elif [ "$n" -gt 30 ]; then
    fail "backup.txt has $n lines — without -n, sed prints every line (and the range twice)"
  elif grep -q 'skipped on staging' "$W/backup.txt"; then
    fail "backup.txt has a line from before the section — use the range /BEGIN/,/END/ (not just /backup/)"
  elif ! grep -q 'dumping database' "$W/backup.txt"; then
    fail "backup.txt has only the markers — use a range with a comma: '/BEGIN/,/END/p'"
  else
    fail "backup.txt has the wrong lines"
    echo "      found: $(tr '\n' '|' < "$W/backup.txt")"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
