#!/bin/sh
# check.sh — checks the lesson 16 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
H="$W/home"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
tab()   { HOME="$H" bash -i -c "$1" 2>/dev/null </dev/null; }      # new terminal tab
login() { HOME="$H" bash -l -i -c "$1" 2>/dev/null </dev/null; }   # SSH login shell

if [ ! -f "$H/.bashrc" ] || [ ! -f "$H/.profile" ]; then
  echo "FAIL  /work/home/.bashrc or .profile is missing — run sh /practice/setup.sh to start over"
  echo; echo "RESULT: FAIL (1 check(s) failed)"; exit 1
fi

# Part 1: alias logs in a new terminal tab
if [ "$(tab 'alias logs')" = "alias logs='tail -n 20 app.log'" ]; then
  pass "a new terminal tab has the alias logs"
elif grep -qs "alias logs=" "$H/.bash_profile" "$H/.profile"; then
  fail "a new terminal tab doesn't have logs — a non-login shell reads only ~/.bashrc"
else fail "a new terminal tab doesn't have the alias logs='tail -n 20 app.log'"
fi

# Part 2: login shells get the aliases from .bashrc
got=$(login 'alias ll; alias gs; alias logs' | grep -c '^alias ')
if [ "$got" = 3 ]; then pass "a login shell (SSH) has ll, gs and logs"
else fail "a login shell (SSH) is missing aliases — it reads only ~/.bash_profile; make it load ~/.profile (which loads ~/.bashrc)"
fi

# Rules: .bash_profile stays and still works, aliases live in one place
if [ ! -f "$H/.bash_profile" ]; then
  fail "~/.bash_profile was removed — the task says to keep it"
elif [ "$(login 'echo "$EDITOR ${PATH%%:*}"' | tail -n 1)" != "nano $H/bin" ]; then
  fail "a login shell lost PATH with ~/bin first or EDITOR=nano from ~/.bash_profile"
else pass "~/.bash_profile still sets PATH and EDITOR"
fi
dup=""
for a in ll gs logs; do
  n=$(cat "$H/.bashrc" "$H/.profile" "$H/.bash_profile" 2>/dev/null | grep -c "^[[:space:]]*alias $a=")
  [ "$n" -gt 1 ] && dup="$dup $a"
done
if [ -z "$dup" ]; then pass "no alias is defined in more than one file"
else fail "defined more than once:$dup — keep aliases only in ~/.bashrc and let the other files load it"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
