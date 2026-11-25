#!/bin/sh
# check.sh — checks the lesson 14 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
S="$W/.state"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

if [ ! -f "$S/5000.pid" ]; then
  echo "FAIL  the practice state is missing — run sh /practice/setup.sh to start over"
  echo; echo "RESULT: FAIL (1 check(s) failed)"; exit 1
fi
want=$(cat "$S/5000.pid")

# Part 1: the PID of the server on port 5000
if [ ! -f "$W/pid.txt" ]; then
  fail "/work/pid.txt does not exist yet"
else
  got=$(tr -d ' \t\r\n' < "$W/pid.txt")
  if [ "$got" = "$want" ]; then pass "pid.txt has the PID of the process on port 5000"
  elif [ -z "$got" ]; then fail "pid.txt is empty — write the PID before you stop the process"
  elif grep -q '[^0-9[:space:]]' "$W/pid.txt"; then
    fail "pid.txt must contain only the number — lsof -t prints just the PID"
  else fail "pid.txt has $got, but that is not the process on port 5000 (try ss -ltnp 'sport = :5000')"
  fi
fi

# Part 2: port 5000 is free, and the process got SIGTERM
if [ -n "$(lsof -t -i :5000 2>/dev/null)" ]; then
  fail "port 5000 is still in use"
elif [ ! -f "$S/5000.exit" ]; then
  fail "port 5000 is free, but the old server's status was not recorded — run sh /practice/setup.sh to start over"
else
  code=$(cat "$S/5000.exit")
  case "$code" in
    143) pass "port 5000 is free, the old server got SIGTERM (exit status 143)" ;;
    137) fail "the old server was killed with SIGKILL (exit status 137) and could not save its data — fuser -k and kill -9 send SIGKILL; use plain kill or fuser -k -TERM" ;;
    *)   fail "the old server ended with exit status $code, not 143 (SIGTERM)" ;;
  esac
fi

# Rule: 3000 and 5432 keep running
for p in 3000 5432; do
  if [ "$(lsof -t -i :$p 2>/dev/null)" = "$(cat "$S/$p.pid")" ]; then pass "the server on port $p is still running"
  else fail "the server on port $p was stopped — only the one on port 5000 had to go"
  fi
done

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
