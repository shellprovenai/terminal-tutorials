#!/bin/sh
# start.sh — opens the lesson 05 practice in a throwaway container (removed when you type exit).
# Nothing on your computer is changed: the practice folder is mounted read-only, the work happens in /work inside the container.
# Tested with rootless podman 5.4 on Debian 13. Works with docker too.
set -e
cd "$(dirname "$0")"
ENGINE=${ENGINE:-$(command -v podman || command -v docker || true)}
[ -n "$ENGINE" ] || { echo "Please install podman (or docker) first."; exit 1; }
exec "$ENGINE" run --rm -it --name practice05 --hostname practice \
  -v "$PWD":/practice:ro,Z -w /work docker.io/library/debian:13 \
  sh -c 'echo "Installing tools (about a minute)..."; apt-get -qq update >/dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends sqlite3 >/dev/null && sh /practice/setup.sh && cd /work && exec bash'
