#!/bin/sh
# start.sh — opens the lesson 17 practice in a throwaway container (removed when you type exit).
# Nothing on your computer is changed: the practice folder is mounted read-only, the work happens in /work inside the container.
# Tested with rootless podman 5.4 on Debian 13. Works with docker too.
set -e
cd "$(dirname "$0")"
ENGINE=${ENGINE:-$(command -v podman || command -v docker || true)}
[ -n "$ENGINE" ] || { echo "Please install podman (or docker) first."; exit 1; }
exec "$ENGINE" run --rm -it --name practice17 --hostname practice \
  -v "$PWD":/practice:ro,Z -w / docker.io/library/debian:13 \
  sh -c 'mkdir -p /work && sh /practice/setup.sh && cd /work && exec bash'
