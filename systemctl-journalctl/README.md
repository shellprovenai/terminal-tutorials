# systemctl and journalctl for people who only need five commands: status, logs, follow, enable

> 🎬 Video: https://youtu.be/5yBAu13oXLg (public from Nov 25, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## 1. systemctl status

```console
$ systemctl start hello-app && sleep 3 && systemctl status hello-app --no-pager -n 2
● hello-app.service - Hello demo app
     Loaded: loaded (/etc/systemd/system/hello-app.service; disabled; preset: enabled)
     Active: active (running) since Sat 2026-11-21 23:17:51 UTC; 3s ago
 Invocation: 1aca39730eac412ea68f0819eba75cb9
   Main PID: 108 (hello-app)
      Tasks: 2 (limit: 307)
     Memory: 404K (peak: 2M)
        CPU: 10ms
     CGroup: /system.slice/hello-app.service
             ├─108 /bin/sh /usr/local/bin/hello-app
             └─113 sleep 2

Nov 21 23:17:51 demo hello-app[108]: tick 23:17:51
Nov 21 23:17:53 demo hello-app[108]: tick 23:17:53
```

## 2. Why did it fail? journalctl -u

```console
$ systemctl start report
Job for report.service failed because the control process exited with error code.
See "systemctl status report.service" and "journalctl -xeu report.service" for details.
```

```console
$ journalctl -u report --no-pager -n 5
Nov 21 23:17:55 demo (ort-tool)[131]: report.service: Unable to locate executable '/usr/local/bin/report-tool': No such file or directory
Nov 21 23:17:55 demo (ort-tool)[131]: report.service: Failed at step EXEC spawning /usr/local/bin/report-tool: No such file or directory
Nov 21 23:17:55 demo systemd[1]: report.service: Main process exited, code=exited, status=203/EXEC
Nov 21 23:17:55 demo systemd[1]: report.service: Failed with result 'exit-code'.
Nov 21 23:17:55 demo systemd[1]: Failed to start report.service - Report job (broken on purpose).
```

```console
$ systemctl status report --no-pager
× report.service - Report job (broken on purpose)
     Loaded: loaded (/etc/systemd/system/report.service; static)
     Active: failed (Result: exit-code) since Sat 2026-11-21 23:17:55 UTC; 14ms ago
 Invocation: 7f7bc45d45024789a802d4210683dc86
    Process: 131 ExecStart=/usr/local/bin/report-tool (code=exited, status=203/EXEC)
   Main PID: 131 (code=exited, status=203/EXEC)
   Mem peak: 1.7M
        CPU: 6ms

Nov 21 23:17:55 demo systemd[1]: Starting report.service - Report job (broken on purpose)...
Nov 21 23:17:55 demo (ort-tool)[131]: report.service: Unable to locate executable '/usr/local/bin/report-tool': No such file or directory
Nov 21 23:17:55 demo (ort-tool)[131]: report.service: Failed at step EXEC spawning /usr/local/bin/report-tool: No such file or directory
Nov 21 23:17:55 demo systemd[1]: report.service: Main process exited, code=exited, status=203/EXEC
Nov 21 23:17:55 demo systemd[1]: report.service: Failed with result 'exit-code'.
Nov 21 23:17:55 demo systemd[1]: Failed to start report.service - Report job (broken on purpose).
```

## 3. Logs since boot, or the last minutes

```console
$ journalctl -b -u hello-app --no-pager | head -4
Nov 21 23:17:51 demo systemd[1]: Started hello-app.service - Hello demo app.
Nov 21 23:17:51 demo hello-app[108]: hello-app starting
Nov 21 23:17:51 demo hello-app[108]: tick 23:17:51
Nov 21 23:17:53 demo hello-app[108]: tick 23:17:53
```

```console
$ journalctl --since "10 min ago" -p err --no-pager
Nov 21 23:17:55 demo (ort-tool)[131]: report.service: Failed at step EXEC spawning /usr/local/bin/report-tool: No such file or directory
Nov 21 23:17:55 demo systemd[1]: Failed to start report.service - Report job (broken on purpose).
```

## 4. Follow logs live

```console
$ timeout 5 journalctl -u hello-app -f --no-pager -n 1
Nov 21 23:17:57 demo hello-app[108]: tick 23:17:57
Nov 21 23:17:59 demo hello-app[108]: tick 23:17:59
Nov 21 23:18:01 demo hello-app[108]: tick 23:18:01
Nov 21 23:18:03 demo hello-app[108]: tick 23:18:03
```

## 5. start vs enable

```console
$ systemctl is-enabled hello-app
disabled
```

```console
$ systemctl stop hello-app && systemctl enable hello-app
Created symlink '/etc/systemd/system/multi-user.target.wants/hello-app.service' → '/etc/systemd/system/hello-app.service'.
```

```console
$ systemctl is-active hello-app
inactive
```

```console
$ systemctl enable --now hello-app && systemctl is-active hello-app && systemctl is-enabled hello-app
active
enabled
```

## Quick check

**Question 1.** I ran systemctl start myapp. Will it start again after a reboot?

**Answer:** No. Use systemctl enable --now myapp — Start means now, enable means at boot. enable --now does both.

**Question 2.** How do I see the logs of one service since the last boot?

**Answer:** journalctl -b -u myapp — -b is the current boot, -u picks the unit. Add -f to follow it live.

Commands that check the answers (run in the same container, after the lesson):

```console
$ systemctl is-enabled hello-app && systemctl is-active hello-app
enabled
active
```

```console
$ journalctl -b -u hello-app --no-pager | head -2
Nov 21 23:17:51 demo systemd[1]: Started hello-app.service - Hello demo app.
Nov 21 23:17:51 demo hello-app[108]: hello-app starting
```

## Files

- `setup.sh` — demo folder
- `systemctl-journalctl.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
