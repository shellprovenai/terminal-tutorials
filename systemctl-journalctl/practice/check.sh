#!/bin/sh
# check.sh — checks the lesson 15 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
R="$W/rootfs"
U="$R/etc/systemd/system/backup.service"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

if [ ! -d "$W/journal" ] || [ ! -f "$U" ] || [ ! -x "$R/usr/local/sbin/backup-run" ]; then
  echo "FAIL  the practice files are missing — run sh /practice/setup.sh to start over"
  echo; echo "RESULT: FAIL (1 check(s) failed)"; exit 1
fi

# Part 1: the missing program from the LAST boot
if [ ! -f "$W/missing.txt" ]; then
  fail "/work/missing.txt does not exist yet"
else
  got=$(tr -d " \t\r'" < "$W/missing.txt" | grep -v '^$')
  case "$got" in
    /usr/local/bin/backup-run) pass "missing.txt names the program from the last boot" ;;
    /opt/backup/run.sh) fail "/opt/backup/run.sh is from the PREVIOUS boot — journalctl -b shows only the last one" ;;
    *) fail "missing.txt should contain only the missing program's path (found: $(echo "$got" | head -3 | tr '\n' ' '))" ;;
  esac
fi

# Part 2a: ExecStart fixed
exec_line=$(grep '^ExecStart=' "$U")
if [ "$exec_line" = "ExecStart=/usr/local/sbin/backup-run" ]; then pass "backup.service now runs /usr/local/sbin/backup-run"
else fail "backup.service should have ExecStart=/usr/local/sbin/backup-run (now: ${exec_line:-no ExecStart line})"
fi
grep -q '^WantedBy=multi-user.target$' "$U" || fail "keep the [Install] section with WantedBy=multi-user.target in backup.service"

# Part 2b: enabled (starts at boot)
L="$R/etc/systemd/system/multi-user.target.wants/backup.service"
if [ -L "$L" ] && [ "$(readlink "$L")" = /etc/systemd/system/backup.service ] \
   && [ "$(systemctl --root="$R" is-enabled backup.service 2>/dev/null)" = enabled ]; then
  pass "backup.service is enabled, it will start at every boot"
else
  fail "backup.service is not enabled — start (or --now) only means now; at boot needs: systemctl --root=/work/rootfs enable backup.service"
fi

# Rule: nginx untouched
if [ "$(systemctl --root="$R" is-enabled nginx.service 2>/dev/null)" = enabled ] \
   && grep -q '^ExecStart=/usr/sbin/nginx -g "daemon off;"$' "$R/usr/lib/systemd/system/nginx.service"; then
  pass "nginx.service is unchanged and still enabled"
else fail "nginx.service was changed or disabled — leave it alone"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
