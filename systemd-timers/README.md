# systemd timers instead of cron: schedule a job, check the next run, read its logs

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## A job as a oneshot service

```console
$ systemctl cat report.service --no-pager
# /etc/systemd/system/report.service
[Unit]
Description=Generate the report

[Service]
Type=oneshot
ExecStart=/usr/local/bin/make-report
```

```console
$ systemctl start report.service && journalctl -u report.service --no-pager -n 4
Nov 22 01:38:38 demo systemd[1]: Starting report.service - Generate the report...
Nov 22 01:38:38 demo make-report[103]: report OK
Nov 22 01:38:38 demo systemd[1]: report.service: Deactivated successfully.
Nov 22 01:38:38 demo systemd[1]: Finished report.service - Generate the report.
```

## The timer

```console
$ systemctl cat report.timer --no-pager
# /etc/systemd/system/report.timer
[Unit]
Description=Run the report every 10 seconds (demo)

[Timer]
OnCalendar=*:*:0/10
AccuracySec=1s
Persistent=true

[Install]
WantedBy=timers.target
```

```console
$ systemctl enable --now report.timer
Created symlink '/etc/systemd/system/timers.target.wants/report.timer' → '/etc/systemd/system/report.timer'.
```

## When does it run next?

```console
$ systemctl list-timers report.timer --no-pager
NEXT                        LEFT LAST PASSED UNIT         ACTIVATES
Sun 2026-11-22 01:38:50 UTC   8s -         - report.timer report.service

1 timers listed.
Pass --all to see loaded but inactive timers, too.
```

## Every run is in the journal

```console
$ sleep 15; journalctl -u report.service --no-pager -n 6
Nov 22 01:38:38 demo systemd[1]: report.service: Deactivated successfully.
Nov 22 01:38:38 demo systemd[1]: Finished report.service - Generate the report.
Nov 22 01:38:50 demo systemd[1]: Starting report.service - Generate the report...
Nov 22 01:38:50 demo make-report[167]: report OK
Nov 22 01:38:50 demo systemd[1]: report.service: Deactivated successfully.
Nov 22 01:38:50 demo systemd[1]: Finished report.service - Generate the report.
```

```console
$ tail -n 3 /var/log/report.log
report generated at 01:38:38
report generated at 01:38:50
```

## Test a schedule with systemd-analyze calendar

```console
$ systemd-analyze calendar "Mon..Fri 02:30" --iterations=3
  Original form: Mon..Fri 02:30
Normalized form: Mon..Fri *-*-* 02:30:00
    Next elapse: Mon 2026-11-23 02:30:00 UTC
       From now: 24h left
   Iteration #2: Tue 2026-11-24 02:30:00 UTC
       From now: 2 days left
   Iteration #3: Wed 2026-11-25 02:30:00 UTC
       From now: 3 days left
```

```console
$ systemd-analyze calendar daily
  Original form: daily
Normalized form: *-*-* 00:00:00
    Next elapse: Mon 2026-11-23 00:00:00 UTC
       From now: 22h left
```

## The trap: edited timer, old schedule

```console
$ sed -i 's|0/10|0/30|' /etc/systemd/system/report.timer && systemctl restart report.timer 2>&1 | head -2
Warning: The unit file, source configuration file or drop-ins of report.timer changed on disk. Run 'systemctl daemon-reload' to reload units.
```

```console
$ systemctl show report.timer -p TimersCalendar
TimersCalendar={ OnCalendar=*-*-* *:*:00/10 ; next_elapse=Sun 2026-11-22 01:39:10 UTC }
```

```console
$ systemctl daemon-reload && systemctl restart report.timer && systemctl show report.timer -p TimersCalendar
TimersCalendar={ OnCalendar=*-*-* *:*:00/30 ; next_elapse=Sun 2026-11-22 01:39:30 UTC }
```

## Quick check

**Question 1.** How do I see when a systemd timer will run next?

**Answer:** systemctl list-timers — It shows the next and the last run of every timer.

**Question 2.** I edited a .timer file. What must I run before restarting it?

**Answer:** systemctl daemon-reload — Without daemon reload, systemd keeps the old version of the unit.

Commands that check the answers (run in the same container, after the lesson):

```console
$ systemctl list-timers report.timer --no-pager | head -2
NEXT                        LEFT LAST                        PASSED UNIT         ACTIVATES
Sun 2026-11-22 01:39:30 UTC  28s Sun 2026-11-22 01:39:00 UTC 1s ago report.timer report.service
```

```console
$ sed -i 's|0/30|0/20|' /etc/systemd/system/report.timer && systemctl show report.timer -p NeedDaemonReload && systemctl daemon-reload && systemctl show report.timer -p NeedDaemonReload
NeedDaemonReload=yes
NeedDaemonReload=no
```

## Files

- `setup.sh` — demo folder
- `systemd-timers.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
