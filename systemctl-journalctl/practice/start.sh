#!/bin/sh
# start.sh — opens the lesson 15 practice in a throwaway container (removed when you type exit).
# Nothing on your computer is changed: the practice folder is mounted read-only, the work happens in /work inside the container.
# No systemd runs in this container: you work on a copied journal and on the disk of a server (/work/rootfs), like a rescue system.
# Tested with rootless podman 5.4 on Debian 13. Works with docker too.
set -e
cd "$(dirname "$0")"
ENGINE=${ENGINE:-$(command -v podman || command -v docker || true)}
[ -n "$ENGINE" ] || { echo "Please install podman (or docker) first."; exit 1; }
exec "$ENGINE" run --rm -it --name practice15 --hostname practice \
  -v "$PWD":/practice:ro,Z -w / docker.io/library/debian:13 \
  sh -c 'mkdir -p /work && echo "Installing tools (about a minute)..."; apt-get -qq update >/dev/null && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends systemd systemd-journal-remote >/dev/null && sh /practice/setup.sh && cd /work && exec bash'
