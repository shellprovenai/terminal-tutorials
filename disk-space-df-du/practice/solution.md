# Solution — lesson 07 practice

**Part 1: folder sizes, smallest first.** `du -sh` prints one human-readable total per argument, and the `*` makes every
folder inside /work/var its own argument. Plain `sort` compares text, so `120M` would land before `24M` and `8.0M`;
`sort -h` understands the units and puts `log` (120M) last.

**Part 2: empty a log that is still open.** If you `rm app.log`, the program keeps the deleted file open and the 70 MB stay
used until the program stops (look in `/proc/*/fd` for `(deleted)`). `truncate -s 0` cuts the file to zero bytes in place:
the space is freed at once, the file stays, and the program keeps writing to it.

```sh
cd /work/var && du -sh * | sort -h > /work/usage.txt
truncate -s 0 /work/var/log/app/app.log
```

Then run `sh /practice/check.sh`: all checks should say PASS.
