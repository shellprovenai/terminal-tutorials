#!/bin/sh
# setup.sh — starts three background programs from /work/bin: a runaway thumbnailer (100% CPU), thumbnail-cache
# (must keep running) and an exporter that cleans up when it gets SIGTERM.
# Meant to run inside the throwaway container from start.sh. Only touches /work (and the processes it started).
set -e
W=${WORK:-/work}
for p in thumbnailer thumbnail-cache exporter; do pkill -x "$p" 2>/dev/null || true; done
sleep 1.5
rm -rf "$W/bin" "$W/culprit.txt" "$W/export.csv" "$W/exporter.lock"
mkdir -p "$W/bin"
printf '#!/bin/sh\nwhile :; do :; done\n' > "$W/bin/thumbnailer"
cp /bin/sleep "$W/bin/thumbnail-cache"
cat > "$W/bin/exporter" <<EOF
#!/bin/bash
trap 'echo END >> $W/export.csv; rm -f $W/exporter.lock; exit 0' TERM
touch $W/exporter.lock
echo id,status > $W/export.csv
n=0
while :; do n=\$((n + 1)); echo "\$n,ok" >> $W/export.csv; sleep 1; done
EOF
chmod +x "$W/bin/thumbnailer" "$W/bin/exporter"
cd "$W"
(setsid bin/thumbnail-cache infinity >/dev/null 2>&1 &)
(setsid bin/exporter >/dev/null 2>&1 &)
(setsid bin/thumbnailer >/dev/null 2>&1 &)
sleep 1
echo
cat /practice/TASK.md 2>/dev/null || true
