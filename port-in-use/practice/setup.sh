#!/bin/sh
# setup.sh — starts three small TCP servers: a web app on 3000, a forgotten old dev server on 5000 and a database on 5432.
# Each one writes how it exited to /work/.state/<port>.exit, so check.sh can tell SIGTERM from SIGKILL.
# Meant to run inside the throwaway container from start.sh. Only touches /work (and the servers it started itself).
set -e
W=${WORK:-/work}
# stop servers left over from an earlier run of this setup
for p in 3000 5000 5432; do
  for pid in $(lsof -t -i :$p 2>/dev/null); do kill "$pid" 2>/dev/null || true; done
done
sleep 0.5
rm -rf "$W/.state" "$W/pid.txt"
mkdir -p "$W/.state"
serve() {   # serve PORT REPLY
  setsid sh -c "socat TCP-LISTEN:$1,reuseaddr,fork SYSTEM:'echo $2' >/dev/null 2>&1; echo \$? > $W/.state/$1.exit" \
    >/dev/null 2>&1 </dev/null &
}
serve 3000 web-app
serve 5000 old-dev-server
serve 5432 database
sleep 1
for p in 3000 5000 5432; do
  pid=$(lsof -t -i :$p)
  [ -n "$pid" ] || { echo "setup: server on port $p did not start"; exit 1; }
  echo "$pid" > "$W/.state/$p.pid"
done
echo
cat /practice/TASK.md 2>/dev/null || true
