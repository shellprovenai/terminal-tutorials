#!/bin/sh
# check.sh — checks the lesson 20 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
API=http://localhost:8080

if ! curl -s "$API/health" >/dev/null 2>&1; then
  fail "the test API on localhost:8080 is not running — run sh /practice/setup.sh to start over"
  echo; echo "RESULT: FAIL ($fails check(s) failed)"; exit 1
fi

# Part 1: the ticket exists on the server
tickets=$(curl -s -H "X-API-Key: k-7f3a9c" "$API/tickets")
stats=$(curl -s "$API/_stats")
n415=$(echo "$stats" | sed -n 's/.*"415": \([0-9]*\).*/\1/p')
n401=$(echo "$stats" | sed -n 's/.*"401": \([0-9]*\).*/\1/p')
if echo "$tickets" | grep -q '"title": "disk full on web1"'; then
  pass "the ticket \"disk full on web1\" was created"
elif echo "$tickets" | grep -q '"title"'; then
  fail "a ticket exists, but its title is not exactly \"disk full on web1\": $tickets"
elif [ "${n415:-0}" -gt 0 ]; then
  fail "no ticket yet — the server answered 415: plain -d sends a form; add -H 'Content-Type: application/json' or use --json"
elif [ "${n401:-0}" -gt 0 ]; then
  fail "no ticket yet — the server answered 401: send the key with -H \"X-API-Key: \$(cat /work/api-key.txt)\""
else
  fail "no ticket yet — POST the JSON to $API/tickets"
fi

# Part 2: backup-check.sh fails on an error answer, still works on a real backup
S="$W/backup-check.sh"
if [ ! -f "$S" ]; then
  fail "/work/backup-check.sh is missing — run sh /practice/setup.sh to start over"
else
  out=$(BACKUP_URL="$API/backups/db1" sh "$S" 2>&1); rc=$?
  if echo "$out" | grep -q "backup OK"; then
    fail "backup-check.sh still says \"backup OK\" on a 404 — curl exits with 0 on error answers; use -f or check %{http_code}"
  elif [ $rc -eq 0 ]; then
    fail "backup-check.sh no longer says \"backup OK\" on a 404, but it still exits with 0 — a script calling it can't see the failure"
  else
    pass "backup-check.sh fails (exit $rc) when the server answers 404"
  fi
  out=$(BACKUP_URL="$API/backups/web1" sh "$S" 2>&1); rc=$?
  if [ $rc -eq 0 ] && echo "$out" | grep -q "backup OK"; then
    pass "backup-check.sh still says \"backup OK\" for a real backup (web1)"
  else
    fail "for a real backup (web1) backup-check.sh should print \"backup OK\" and exit 0 (got exit $rc: $out)"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
