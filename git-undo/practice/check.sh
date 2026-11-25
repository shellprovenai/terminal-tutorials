#!/bin/sh
# check.sh — checks the lesson 03 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
S="$W/shop"; O="$W/origin.git"

if ! git -C "$S" rev-parse -q --verify HEAD >/dev/null 2>&1 || ! git -C "$O" rev-parse -q --verify main >/dev/null 2>&1; then
  echo "FAIL  /work/shop or /work/origin.git is broken — run sh /practice/setup.sh to start over"
  echo; echo "RESULT: FAIL (1 check(s) failed)"; exit 1
fi

# Part 1: secrets.env unstaged, still on disk, never committed
if [ ! -f "$S/secrets.env" ]; then
  fail "secrets.env was deleted — git restore --staged keeps the file on disk"
elif git -C "$S" log --all --format=%h -- secrets.env | grep -q . || git -C "$O" log --all --format=%h -- secrets.env | grep -q .; then
  fail "secrets.env ended up in a commit — it must never be committed"
elif git -C "$S" ls-files --error-unmatch secrets.env >/dev/null 2>&1; then
  fail "secrets.env is still staged (git status shows A in the first column)"
else pass "secrets.env is unstaged, still on disk and in no commit"
fi

# Rule: the uncommitted notes.txt edit survives and stays uncommitted
if ! grep -q "call the supplier" "$S/notes.txt" 2>/dev/null; then
  fail "your uncommitted edit in notes.txt is gone — reset --hard wipes uncommitted changes, and git has no copy"
elif git -C "$S" show HEAD:notes.txt 2>/dev/null | grep -q "call the supplier"; then
  fail "the notes.txt edit was committed — the task says to keep it uncommitted"
else pass "the notes.txt edit is still there, uncommitted"
fi

# Part 2: the pushed commit is undone with a new commit, shared history kept
hist=$(git -C "$O" log --format=%s main)
if ! echo "$hist" | grep -qx "Raise mug price to 99"; then
  fail "origin no longer has \"Raise mug price to 99\" — you rewrote shared history; use git revert, not reset"
elif [ "$(git -C "$O" show main:prices.csv 2>/dev/null | grep '^mug,')" != "mug,12" ]; then
  if [ "$(git -C "$S" show HEAD:prices.csv 2>/dev/null | grep '^mug,')" = "mug,12" ]; then
    fail "the fix is only in your clone — push it to origin"
  else fail "on origin the mug still doesn't cost 12"
  fi
elif [ "$(echo "$hist" | head -1)" != 'Revert "Raise mug price to 99"' ]; then
  fail "the newest commit on origin should be the revert of \"Raise mug price to 99\""
else pass "origin has the original commit plus its revert, the mug costs 12"
fi

# Part 2: the teammate can simply pull (fast-forward)
T=$(mktemp -d)
cp -r "$W/mate" "$T/mate"
if git -C "$T/mate" pull -q --ff-only >/dev/null 2>&1 && [ "$(grep '^mug,' "$T/mate/prices.csv")" = "mug,12" ]; then
  pass "your teammate can pull the fix with a plain git pull"
else fail "your teammate can't get the fix with a plain (fast-forward) pull"
fi
rm -rf "$T"

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
