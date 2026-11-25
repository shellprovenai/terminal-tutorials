#!/bin/sh
# check.sh — checks the lesson 09 practice. Run it inside the practice container: sh /practice/check.sh
# It runs your crontab line the way cron does: env -i with cron's variables (HOME=/root, PATH=/usr/bin:/bin, SHELL=/bin/sh)
# plus the NAME=value lines of your crontab (cron doesn't expand $ in them), in /root, with sh -c, and with cron's % rule
# (a plain % ends the command, \% becomes %).
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
C="$W/dump.cron"
today=$(date +%F)

# Rule: dump.sh and dumptool unchanged
if [ "$(cat "$W/jobs/dump.sh" 2>/dev/null)" = '#!/bin/sh
dumptool shop > dump.sql
echo "dump done: $(wc -l < dump.sql) lines"' ] && grep -q 'warning: table sessions skipped' "$W/bin/dumptool" 2>/dev/null && [ -x "$W/bin/dumptool" ]; then
  pass "dump.sh and dumptool are unchanged"
else fail "dump.sh or dumptool was changed — fix the crontab, not the script (run sh /practice/setup.sh to start over)"
fi

if [ ! -s "$C" ]; then
  fail "/work/dump.cron does not exist yet"
  echo; echo "RESULT: FAIL ($fails check(s) failed)"; exit 1
fi

# Installed?
if [ "$(crontab -l 2>/dev/null)" = "$(cat "$C")" ]; then pass "dump.cron is installed (crontab -l shows the same lines)"
elif crontab -l >/dev/null 2>&1; then fail "the installed crontab is not the same as /work/dump.cron — after every change run crontab /work/dump.cron again"
else fail "no crontab is installed — run crontab /work/dump.cron"
fi

# One job line, every day at 02:30
jobs=$(grep -Ev '^[[:space:]]*(#|$)' "$C" | grep -Ev '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=')
n=$(printf '%s\n' "$jobs" | grep -c .)
if [ "$n" -ne 1 ]; then
  fail "dump.cron should have exactly one job line (found $n)"
  echo; echo "RESULT: FAIL ($fails check(s) failed)"; exit 1
fi
set -f; set -- $jobs; set +f
if [ "$1" = 30 ] && { [ "$2" = 2 ] || [ "$2" = 02 ]; } && [ "$3 $4 $5" = '* * *' ]; then pass "the job runs every day at 02:30"
else fail "the time fields are \"$1 $2 $3 $4 $5\" — every day at 02:30 is: 30 2 * * *"
fi

# Run it like cron
cmd=$(printf '%s\n' "$jobs" | sed -E 's/^[[:space:]]*([^[:space:]]+[[:space:]]+){5}//')
plainpct=$(printf '%s' "$cmd" | sed 's/\\%//g' | grep -c '%')
ccmd=$(printf '%s' "$cmd" | sed -e 's/\\%/\x01/g' -e 's/%.*//' -e 's/\x01/%/g')
envs=$(grep -E '^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*[[:space:]]*=' "$C" | sed -E -e 's/^[[:space:]]*//' -e 's/[[:space:]]*=[[:space:]]*/=/' -e "s/=([\"'])(.*)\\1[[:space:]]*\$/=\\2/")
rm -f "$W/jobs/dump.sql" /root/dump.sql "$W"/logs/*.log
out=$(cd /root && printf '%s\n' "$envs" | { set -f; IFS='
'; set -- $(cat); exec timeout 20 env -i HOME=/root LOGNAME=root SHELL=/bin/sh PATH=/usr/bin:/bin "$@" /bin/sh -c "$ccmd"; } 2>&1)
logs=$(cat "$W"/logs/*.log 2>/dev/null)
all="$out
$logs"

if echo "$all" | grep -q 'dumptool: not found'; then
  fail "in cron the job says \"dumptool: not found\" — cron's PATH is only /usr/bin:/bin; add a PATH=... line with /work/bin at the top of dump.cron"
elif [ -f /root/dump.sql ]; then
  fail "dump.sql landed in /root — cron starts in the home folder; cd /work/jobs before running the script"
elif [ ! -f "$W/jobs/dump.sql" ] || [ "$(wc -l < "$W/jobs/dump.sql")" != 3 ]; then
  fail "after the run there is no complete /work/jobs/dump.sql (the job printed: $(echo "$out" | head -3 | tr '\n' ' '))"
else pass "in cron's environment the job finds dumptool and writes /work/jobs/dump.sql"
fi

if [ "$plainpct" -gt 0 ]; then
  fail "the job line has a plain % — cron cuts the command there, so the part after it (your log redirection) never runs; write \\% instead"
elif ! echo "$logs" | grep -q 'dump done: 3 lines'; then
  fail "nothing was logged in /work/logs — append the output with >> /work/logs/..."
elif ! echo "$logs" | grep -q 'warning: table sessions skipped'; then
  fail "the log has the output but not the errors — add 2>&1 AFTER the >> redirection"
else pass "the output and the errors are appended to the log"
fi

if [ -f "$W/logs/dump-$today.log" ] && grep -q 'dump done' "$W/logs/dump-$today.log"; then pass "the log file is named with today's date (dump-$today.log)"
elif [ -f "$W/logs/dump.log" ]; then fail "the log still goes to dump.log — part 2: name it dump-\$(date +\\%F).log"
else fail "no /work/logs/dump-$today.log after the run (found: $(ls "$W/logs" | tr '\n' ' '))"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
