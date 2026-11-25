#!/bin/sh
# check.sh — checks the lesson 02 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
clean() { sed -e 's|^/work/shop/||' -e 's|^\./||' -e 's|^shop/||' -e 's|^\./||' | grep -v '^$' | sort; }   # accept ./x, shop/x, /work/shop/x or x

sum=$(cd "$W/shop" 2>/dev/null && find . -type f | sort | xargs cat 2>/dev/null | cksum)
[ "$(find "$W/shop" -type f 2>/dev/null | wc -l)" -eq 10 ] && [ "$sum" = "99803956 449" ] \
  && pass "/work/shop is unchanged" || fail "files in /work/shop were changed, removed or added — run sh /practice/setup.sh to start over"

X="--exclude-dir=node_modules --exclude-dir=.git --exclude-dir=build"
want1=$(cd "$W/shop" && grep -rniI fixme $X . | clean)
if [ ! -f "$W/fixme.txt" ]; then
  fail "/work/fixme.txt does not exist yet"
else
  got=$(clean < "$W/fixme.txt")
  if [ "$got" = "$want1" ]; then pass "fixme.txt has exactly the project's own fixme lines"
  elif echo "$got" | grep -q node_modules; then
    fail "fixme.txt has lines from node_modules — --exclude-dir=node_modules takes a folder NAME and skips it at any depth"
  elif echo "$got" | grep -q -e '^\.git/' -e '^build/' -e 'binary file'; then
    fail "fixme.txt has lines from .git, build or the binary — exclude those folders too (and use -I)"
  elif ! echo "$got" | grep -q 'cart\.py'; then
    fail "fixme.txt misses the lowercase '# fixme' in app/cart.py — grep is case-sensitive, add -i"
  elif ! echo "$got" | grep -q '^app/server\.js:1:'; then
    fail "fixme.txt lines need the line number, like ./app/server.js:1:... — add -n"
  else
    fail "fixme.txt has the wrong lines"
    echo "      expected: $(echo "$want1" | tr '\n' '|')"
    echo "      found:    $(echo "$got" | tr '\n' '|')"
  fi
fi

want2=$(cd "$W/shop" && grep -rlIF "api.v2" $X . | clean)
if [ ! -f "$W/files.txt" ]; then
  fail "/work/files.txt does not exist yet"
else
  got=$(clean < "$W/files.txt")
  if [ "$got" = "$want2" ]; then pass "files.txt lists exactly the files with the text api.v2"
  elif echo "$got" | grep -q -e 'legacy\.py' -e 'notes\.md'; then
    fail "files.txt lists legacy.py or notes.md (api_v2, api-v2) — in a pattern a dot matches any character; use -F"
  elif echo "$got" | grep -q 'bin/shopd'; then
    fail "files.txt lists the binary bin/shopd — add -I to skip binary files"
  elif echo "$got" | grep -q -e node_modules -e '^\.git/' -e '^build/'; then
    fail "files.txt lists files from node_modules, .git or build — skip those folders with --exclude-dir"
  else fail "files.txt has the wrong files ($(echo "$got" | tr '\n' ' '))"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
