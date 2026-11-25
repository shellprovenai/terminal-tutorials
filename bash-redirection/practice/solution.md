# Solution — lesson 06 practice

**Part 1: append both streams.** `>>` adds to the end of the file, so the old runs stay (a single `>` would wipe them).
The errors travel on stream two, so add `2>&1`, and put it *after* the file: bash reads redirections left to right,
and `2>&1 >> file` would still send the errors to the screen.

**Part 2: count the errors through a pipe.** A pipe only carries stdout, so `./nightly.sh | grep -c ERROR` counts 0.
With `2>&1` before the `|`, both streams go into grep. `^ERROR:` matches only lines that start with it, and `-c`
prints the count instead of the lines.

```sh
cd /work && ./nightly.sh >> logs/nightly.log 2>&1
cd /work && ./nightly.sh 2>&1 | grep -c '^ERROR:' > error-count.txt
```

Then run `sh /practice/check.sh`: all checks should say PASS.
