#!/bin/sh
# setup.sh — builds the practice folder /work/shop (a small web shop project with dependencies, git data, a build and a binary).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/shop" "$W/fixme.txt" "$W/files.txt"
mkdir -p "$W/shop/app" "$W/shop/docs" "$W/shop/config" "$W/shop/node_modules/express" \
  "$W/shop/frontend/node_modules/chart" "$W/shop/.git/hooks" "$W/shop/build" "$W/shop/bin"
cd "$W/shop"
printf '// FIXME: close the db on exit\nconst base = "/api.v2/users"\nmodule.exports = base\n' > app/server.js
printf 'def total(items):\n    # fixme: slow loop\n    return sum(items)\n' > app/cart.py
printf "OLD_URL = '/api_v2/orders'\n" > app/legacy.py
printf '# Notes\nMove all clients to api-v2 soon.\nKnown issue: the FIXME list is in app/.\n' > docs/notes.md
printf '[api]\nendpoint = api.v2\ntimeout = 30\n' > config/settings.ini
printf '// FIXME upstream\nmodule.exports = {}\n' > node_modules/express/index.js
printf '// fixme: vendor code\nconst v = "api.v2"\n' > frontend/node_modules/chart/index.js
printf '#!/bin/sh\n# FIXME sample hook\n' > .git/hooks/pre-commit.sample
printf 'var a="/api.v2/users";/*FIXME*/' > build/bundle.js
printf '\000\001ELF api.v2 FIXME\000' > bin/shopd
echo
cat /practice/TASK.md 2>/dev/null || true
