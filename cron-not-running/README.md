# Cron job not running? It works in the terminal, here's why it fails in cron

> 🎬 Video: https://youtu.be/c2R8fSO_8Uo (public from Nov 26, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## A script that works

```console
$ cat backup.sh
#!/bin/sh
report-tool > report.txt
echo "saved report"
```

```console
$ ./backup.sh && cat report.txt
saved report
report for demo: 42 orders
```

## Schedule it, and log the output

```console
$ cat first.cron
# min hour day month weekday  command
* * * * * /lab/jobs/backup.sh >> /tmp/backup.log 2>&1
* * * * * env > /tmp/cron-env.txt
```

```console
$ crontab first.cron && crontab -l
# min hour day month weekday  command
* * * * * /lab/jobs/backup.sh >> /tmp/backup.log 2>&1
* * * * * env > /tmp/cron-env.txt
```

## Why it fails

```console
$ cat /tmp/backup.log
/lab/jobs/backup.sh: 2: report-tool: not found
saved report
```

```console
$ cat /tmp/cron-env.txt
HOME=/root
LOGNAME=root
PATH=/usr/bin:/bin
SHELL=/bin/sh
PWD=/root
```

```console
$ ls /root
report.txt
```

## The fix: PATH and cd in the crontab

```console
$ cat fixed.cron
PATH=/usr/local/bin:/usr/bin:/bin
# min hour day month weekday  command
* * * * * cd /lab/jobs && ./backup.sh >> /tmp/backup.log 2>&1
* * * * * echo "ran at $(date +%H:%M)" >> /tmp/broken.log
* * * * * echo "ran at $(date +\%H:\%M)" >> /tmp/fixed.log
```

```console
$ crontab fixed.cron

```

## Check it

```console
$ tail -n 1 /tmp/backup.log && cat report.txt
saved report
report for demo: 42 orders
```

## The percent-sign trap

```console
$ cat /tmp/broken.log
cat: /tmp/broken.log: No such file or directory
```

```console
$ cat /tmp/fixed.log
ran at 20:08
```

## Quick check

**Question 1.** My script works by hand, but in cron it says report-tool: not found. Why?

**Answer:** cron's PATH is only /usr/bin:/bin — Set a path line at the top of the crontab, or call the program by its full path.

**Question 2.** What does a plain % sign do inside a crontab line?

**Answer:** It starts a new line and cuts the command — Escape every percent sign with a backslash, or move the command into a script.

Commands that check the answers (run in the same container, after the lesson):

```console
$ grep '^PATH=' /tmp/cron-env.txt
PATH=/usr/bin:/bin
```

```console
$ cat /tmp/broken.log
cat: /tmp/broken.log: No such file or directory
```

```console
$ cat /tmp/fixed.log
ran at 20:08
```

## Files

- `setup.sh` — demo folder
- `cron-debug.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
