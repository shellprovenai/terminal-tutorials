# Solution — lesson 14 practice

**Part 1: who holds port 5000.** `ss -ltnp 'sport = :5000'` shows the process and its PID, and `lsof -t -i :5000`
prints only the PID, so it can go straight into the file.

**Part 2: free the port politely.** Plain `kill` sends SIGTERM, so the server can save its data and exit with status
143. `fuser -k 5000/tcp` (or `kill -9`) would also free the port, but it sends SIGKILL (status 137), which can't be
caught. If you prefer fuser, use `fuser -k -TERM 5000/tcp`.

```sh
lsof -t -i :5000 > /work/pid.txt
kill $(cat /work/pid.txt); sleep 1
```

Then run `sh /practice/check.sh`: all checks should say PASS.
