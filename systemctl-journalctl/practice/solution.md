# Solution — lesson 15 practice

**Part 1: why did it fail in the last boot?** `journalctl -D /work/journal -u backup` shows the logs of the unit from
both boots, and the previous boot failed for a different reason (`/opt/backup/run.sh`). Add `-b`, and you only get the
last boot: the missing program is `/usr/local/bin/backup-run`. `-p err` keeps just the error lines:
`journalctl -D /work/journal -b -u backup -p err --no-pager`. The first line below copies the path into the file.

**Part 2: fix it and make it start at boot.** Change the `ExecStart=` line, then enable the unit. Starting it would
only mean "now" (and is impossible here, and so is `enable --now`): "at every boot" is `enable`, which creates the link
in `multi-user.target.wants`. On a running server you would run `systemctl daemon-reload` after editing the file, and
`systemctl enable --now backup` to do both.

```sh
journalctl -D /work/journal -b -u backup -p err --no-pager | grep -o "executable '[^']*'" | cut -d"'" -f2 > /work/missing.txt
sed -i 's|^ExecStart=.*|ExecStart=/usr/local/sbin/backup-run|' /work/rootfs/etc/systemd/system/backup.service
systemctl --root=/work/rootfs enable backup.service
```

Then run `sh /practice/check.sh`: all checks should say PASS.
