#!/bin/sh
# setup.sh — writes /work/orders.csv (ten orders of a small online shop, with a header line).
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
mkdir -p "$W"
rm -f "$W/orders.csv" "$W/shop.db" "$W/top.csv"
printf 'id,day,city,total\n1001,2026-04-02,Gdansk,1250.00\n1002,2026-04-02,Krakow,89.90\n1003,2026-04-03,Poznan,430.00\n1004,2026-04-05,Krakow,975.50\n1005,2026-04-07,Gdansk,99.00\n1006,2026-04-08,Poznan,64.20\n1007,2026-04-09,Krakow,210.00\n1008,2026-04-11,Gdansk,18.50\n1009,2026-04-12,Poznan,9.99\n1010,2026-04-14,Krakow,1500.00\n' > "$W/orders.csv"
echo
cat /practice/TASK.md 2>/dev/null || true
