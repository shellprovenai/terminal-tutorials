# Solution — lesson 18 practice

**Part 1: edit server.conf in place, with a backup.** `/^#/d` deletes only lines that start with a hash; a careless
`/#/d` would also delete `motd=` and `theme_color=`, which have a `#` inside. `s/old\.example\.com/new.example.com/g`
replaces every match on the line (without `g`, the proxy line keeps its second old name; `\.` makes the dot a real dot).
Do both edits in ONE `sed -i.bak` run, joined with `;`: a second `-i.bak` run would overwrite the backup with the
half-edited file. Try it without `-i` first to see the result.

**Part 2: print a section of the log.** `-n` turns off automatic printing and `/^=== BEGIN/,/^=== END/p` prints from
the first marker to the second, both included. A plain `/backup/p` would also catch the "backup skipped" line and miss
the lines in between.

```sh
cd /work && sed -i.bak '/^#/d; s/old\.example\.com/new.example.com/g' server.conf
cd /work && sed -n '/^=== BEGIN/,/^=== END/p' cron.log > backup.txt
```

Then run `sh /practice/check.sh`: all checks should say PASS.
