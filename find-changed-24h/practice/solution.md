# Solution — lesson 01 practice

**Part 1: the last 24 hours, without site/cache, safe for spaces.** `-prune` skips the cache folder, `-print` makes sure the
folder itself isn't listed, `-mmin -1440` is exactly 24 hours, and `-print0` with `tar --null -T -` keeps
`about us.html` in one piece.

**Part 2: older than exactly 72 hours.** `-mtime +3` drops the fraction of a day first, so it really means "at least 4
whole days" and misses `img/logo.png` (80 hours). Count in minutes instead: 72 × 60 = 4320.

```sh
cd /work/site && find . -path ./cache -prune -o -type f -mmin -1440 -print0 | tar --null -T - -czf /work/changed.tgz
cd /work/site && find . -type f -mmin +4320 | sort > /work/old.txt
```

Then run `sh /practice/check.sh`: all checks should say PASS.
