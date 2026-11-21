#!/usr/bin/env bash
# Demo folder used in the video. Run in an empty directory (ideally in a container):
#   podman run --rm -it docker.io/library/debian:13 bash
set -euo pipefail
mkdir -p /lab/app && cd /lab/app
mkdir -p src node_modules/left-pad .git dist bin logs
printf 'def login(user):\n    # TODO: rate limit\n    return check(user)\n' > src/auth.py
printf 'import auth\n# todo: remove debug flag\nDEBUG = True\nVERSION = "1.5"\n' > src/main.py
printf '// TODO: handle errors\nfetch("/api/catalog")\n' > src/client.js
printf '// TODO upstream bug\nmodule.exports = 1\n' > node_modules/left-pad/index.js
printf '[core]\n\t# TODO nothing\n' > .git/config
printf 'function a(){/*TODO*/return 1}' > dist/app.min.js
printf '\000\001ELF TODO\000' > bin/tool
printf '2026 login ok\n2026 user log out\nversion 105 started\n' > logs/app.log
