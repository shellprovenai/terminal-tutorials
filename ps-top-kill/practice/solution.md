# Solution — lesson 13 practice

**Part 1: find the culprit, stop only that.** `ps aux --sort=-%cpu | head -3` shows `/work/bin/thumbnailer` at the top
with almost 100% CPU. To write just the name in one line, `ps -eo comm` prints only process names and `--no-headers`
drops the title line. In a script it's safer to sort by the CPU time used so far (`--sort=-time`): a shell that has
just started can show a high %CPU for a moment. `pkill -x thumbnailer` matches the exact name. A pattern like
`pkill thumb` would also stop `thumbnail-cache`: run `pgrep -a thumb` first and you'll see both.

**Part 2: let the exporter clean up.** Plain `pkill` (or `kill PID`) sends SIGTERM, which the exporter catches: it writes
END and removes its lock file. `kill -9` (SIGKILL) can't be caught, so it would leave the lock behind.

```sh
ps -eo comm --sort=-time --no-headers | head -1 > /work/culprit.txt && pkill -x thumbnailer
pkill -x exporter
```

Then run `sh /practice/check.sh`: all checks should say PASS.
