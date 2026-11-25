#!/bin/sh
# setup.sh — builds the practice folder /work/site (a small website project with files of different ages).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/site" "$W/changed.tgz" "$W/old.txt"
mkdir -p "$W/site/css" "$W/site/js" "$W/site/img" "$W/site/cache" "$W/site/old"
cd "$W/site"
for f in index.html "about us.html" css/style.css cache/page1.html cache/page2.html js/app.js README.md img/logo.png LICENSE old/v1.html; do
  echo "demo" > "$f"
done
touch -d "10 minutes ago" index.html
touch -d "3 hours ago" "about us.html"
touch -d "20 hours ago" css/style.css
touch -d "1 hour ago" cache/page1.html
touch -d "2 hours ago" cache/page2.html
touch -d "30 hours ago" js/app.js
touch -d "47 hours ago" README.md
touch -d "80 hours ago" img/logo.png
touch -d "100 hours ago" LICENSE
touch -d "6 days ago" old/v1.html
echo
cat /practice/TASK.md 2>/dev/null || true
