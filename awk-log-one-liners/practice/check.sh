#!/bin/sh
# check.sh — checks the lesson 10 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
norm() { sed -e 's/[[:space:]]\{1,\}/ /g' -e 's/^ //' -e 's/ $//' "$1" | grep -v '^$'; }   # any spaces or tabs between columns

if [ "$(md5sum < "$W/app.log" 2>/dev/null | cut -d' ' -f1)" = "3c243e4b3a5941713ed243ead8771496" ]; then pass "app.log is unchanged"
else fail "app.log was changed — run sh /practice/setup.sh to start over"
fi

want1="tom 2300
ben 1180
anna 1450
mia 5000"
if [ ! -f "$W/report/slow.txt" ]; then fail "/work/report/slow.txt does not exist yet"
else
  got=$(norm "$W/report/slow.txt")
  if [ "$got" = "$want1" ]; then pass "slow.txt lists the 4 slow requests as \"user ms\""
  elif [ -z "$got" ]; then fail "slow.txt is empty — if awk said \"syntax error\", the program was in double quotes; use single quotes"
  elif [ "$(echo "$got" | sort)" = "$(echo "$want1" | sort)" ]; then fail "slow.txt has the right lines, but not in log order — don't sort it"
  else
    fail "slow.txt is wrong (found: $(echo "$got" | tr '\n' ',' | sed 's/,$//'))"
    echo "      hint: the duration is the LAST field, \$NF — a fixed column like \$6 hits a word of the message"
  fi
fi

want2="mia 5730
tom 2365
anna 1585
ben 1565"
if [ ! -f "$W/report/users.txt" ]; then fail "/work/report/users.txt does not exist yet"
else
  got=$(norm "$W/report/users.txt")
  if [ "$got" = "$want2" ]; then pass "users.txt has the total per user, biggest first"
  elif [ "$(echo "$got" | sort)" = "$(echo "$want2" | sort)" ]; then fail "users.txt has the right totals, but not biggest first — sort by the number: sort -k2 -rn"
  else
    fail "users.txt has the wrong totals (found: $(echo "$got" | tr '\n' ',' | sed 's/,$//'))"
    echo "      hint: add up \$NF (the last field) per user in an array, print it in END"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
