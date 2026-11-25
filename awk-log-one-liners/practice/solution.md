# Solution — lesson 10 practice

**Part 1: slow requests.** The messages have different numbers of words, so the duration isn't always in the same
column. `$NF` is always the last field. The condition `$NF > 1000` picks the lines, and `{print $2, $NF}` prints the
user and the duration, in log order.

**Part 2: total time per user.** An array indexed by the user adds up `$NF` on every line, and the `END` block prints
one line per user. awk doesn't promise any order in `for (u in t)`, so `sort -k2 -rn` sorts by the second column,
as a number, biggest first.

```sh
cd /work && awk '$NF > 1000 {print $2, $NF}' app.log > report/slow.txt
cd /work && awk '{t[$2] += $NF} END {for (u in t) print u, t[u]}' app.log | sort -k2 -rn > report/users.txt
```

Then run `sh /practice/check.sh`: all checks should say PASS.
