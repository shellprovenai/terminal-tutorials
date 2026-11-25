#!/bin/sh
# check.sh — checks the lesson 04 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
A="$W/app"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
as() { u=$1; shift; su -s /bin/sh "$u" -c "cd $A && $*" >/dev/null 2>&1; }
mode() { stat -c %a "$A/$1" 2>/dev/null; }
clean() { sed -e 's|^\./||' -e 's|^.*/work/app/||' -e 's|^app/||' | grep -v '^$' | sort; }

# Rules: all files still there, owners unchanged
n=$(find "$A" -type f 2>/dev/null | wc -l)
own=$(find "$A" ! -user dave -o ! -group devs 2>/dev/null | wc -l)
if [ "$n" -ne 6 ]; then fail "files in /work/app were removed or added — run sh /practice/setup.sh to start over"
elif [ "$own" -ne 0 ]; then fail "an owner or group was changed — the task says to leave owners alone (dave:devs)"
else pass "/work/app still has its 6 files, all owned by dave:devs"
fi

# Part 1a: the list of world-writable files
want="img/logo.png
index.php
run.sh"
if [ ! -f "$W/writable.txt" ]; then
  fail "/work/writable.txt does not exist yet"
else
  got=$(clean < "$W/writable.txt")
  if [ "$got" = "$want" ]; then pass "writable.txt lists exactly the 3 world-writable files"
  elif [ -z "$got" ]; then fail "writable.txt is empty — did you write -perm o=w? Without the dash find wants that exact mode; use -perm -o=w"
  else fail "writable.txt has the wrong files ($(echo "$got" | tr '\n' ' '))"
  fi
fi

# Part 1b: the files are fixed, nothing is world-writable any more
left=$(find "$A" -perm -o=w 2>/dev/null | wc -l)
if [ "$left" -ne 0 ]; then
  fail "something in /work/app is still writable by everyone (find /work/app -perm -o=w) — 777 is never the fix"
elif [ "$(mode run.sh)" != 755 ]; then
  fail "run.sh has mode $(mode run.sh), it should be 755 (everyone may run it, only dave may change it)"
elif [ "$(mode index.php)" != 644 ] || [ "$(mode img/logo.png)" != 644 ]; then
  fail "index.php and img/logo.png should be 644 (now $(mode index.php) and $(mode img/logo.png))"
elif as erin ./run.sh && as mallory ./run.sh && ! as mallory "echo x >> run.sh"; then
  pass "run.sh 755, index.php and logo.png 644: everyone can use them, only dave can change them"
else fail "run.sh does not behave as expected — erin and mallory should run it, but not change it"
fi

# Part 2a: db.env only for dave
if [ "$(mode db.env)" != 600 ]; then
  if as mallory cat db.env; then fail "mallory can still read db.env (mode $(mode db.env)) — a secret should be 600"
  else fail "db.env has mode $(mode db.env), it should be 600 (read and write for dave, nothing for others)"
  fi
elif as dave "cat db.env" && ! as erin "cat db.env" && ! as mallory "cat db.env"; then
  pass "db.env is 600: only dave can read it"
else fail "db.env: only dave should be able to read it"
fi

# Part 2b: the private folder
pm=$(mode private)
if as mallory "ls private" || as mallory "cat private/notes.txt"; then
  fail "mallory can still get into private (mode $pm) — take everything away from others"
elif ! as erin "cat private/notes.txt"; then
  case $pm in
    74*|76*) fail "erin (group devs) can't open private/notes.txt — on a folder, r only lists names; the group also needs x to enter it" ;;
    *) fail "erin (group devs) can't list private or open notes.txt (mode $pm) — the group needs r and x on the folder" ;;
  esac
elif [ "$pm" != 750 ]; then
  fail "private has mode $pm, it should be 750 (dave rwx, devs r-x, others nothing)"
elif ! as erin "ls private"; then fail "erin can't list private"
else pass "private is 750: dave everything, devs can list and enter, mallory is out"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
