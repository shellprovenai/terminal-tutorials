# Solution — lesson 09 practice

**Part 1: make it work in cron's environment.** Cron's PATH is only `/usr/bin:/bin`, so a `PATH=` line at the top of the
crontab adds `/work/bin` for every job below it (cron doesn't expand `$PATH` there, so write the folders out). The job
starts in `/root`, so `cd /work/jobs &&` makes `dump.sql` land in the right folder. `>> /work/logs/dump.log` appends the
output, and `2>&1` after it sends the warning on stderr to the same log. `crontab FILE` installs the file.

**Part 2: one log per day.** In a crontab line a plain `%` means "new line": cron cuts the command there, and the log
redirection after it would never run. Escape it as `\%`. Install the new version again, since `crontab` keeps a copy and
doesn't watch your file.

```sh
printf '%s\n' 'PATH=/work/bin:/usr/bin:/bin' '30 2 * * * cd /work/jobs && ./dump.sh >> /work/logs/dump.log 2>&1' > /work/dump.cron && crontab /work/dump.cron
printf '%s\n' 'PATH=/work/bin:/usr/bin:/bin' '30 2 * * * cd /work/jobs && ./dump.sh >> /work/logs/dump-$(date +\%F).log 2>&1' > /work/dump.cron && crontab /work/dump.cron
```

Then run `sh /practice/check.sh`: all checks should say PASS.
