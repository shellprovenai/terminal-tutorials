#!/bin/sh
# setup.sh — builds the practice repositories in /work: origin.git (the shared "server" repository),
# shop (your clone, with a staged secret and an uncommitted edit) and mate (a teammate's clone).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/origin.git" "$W/shop" "$W/mate"
mkdir -p "$W"
cd "$W"
git init -q --bare -b main origin.git
git clone -q origin.git shop 2>/dev/null
cd shop
git config user.name "You"
git config user.email "you@example.com"
git config color.ui false
printf '<h1>Our shop</h1>\n' > index.html
printf 'item,price\nmug,12\nshirt,25\n' > prices.csv
git add . && git commit -qm "Add shop page"
printf 'TODO\n- new photos\n' > notes.txt
git add notes.txt && git commit -qm "Add notes"
printf 'item,price\nmug,99\nshirt,25\n' > prices.csv
git commit -qam "Raise mug price to 99"
git push -q -u origin main 2>/dev/null
cd "$W" && git clone -q origin.git mate
cd shop
echo "- call the supplier on Monday" >> notes.txt
echo "API_KEY=sk-test-4f9a2c" > secrets.env
git add secrets.env
echo
cat /practice/TASK.md 2>/dev/null || true
