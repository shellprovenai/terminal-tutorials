# What's eating your CPU? Find it with ps and top, and stop it safely (SIGTERM vs SIGKILL)

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Find the busy process: ps --sort

```console
$ ps aux --sort=-%cpu | head -4
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root          38 98.0  0.0   2672  1928 ?        Rs   21:18   0:01 /bin/sh /usr/local/bin/busy
root          29  1.4  0.0   4056  3116 ?        Ss   21:18   0:00 bash --norc --noprofile /tmp/.sp_seg.sh
root           1  0.3  0.0   1032   744 ?        Ss   21:18   0:00 /run/podman-init -- sleep infinity
```

```console
$ ps -eo pid,rss,comm --sort=-rss | head -4
    PID   RSS COMMAND
     47  3504 ps
     40  3196 worker.sh
     29  3116 bash
```

## top in one snapshot

```console
$ top -b -n 1 -w 76 | head -10
top - 21:18:23 up 11:44,  0 users,  load average: 4.16, 4.63, 4.23
Tasks:   8 total,   2 running,   6 sleeping,   0 stopped,   0 zombie
%Cpu(s): 25.0 us,  0.0 sy,  0.0 ni, 47.9 id, 22.9 wa,  0.0 hi,  4.2 si,  0.0
MiB Mem :   7947.9 total,   1889.8 free,   1961.8 used,   4427.5 buff/cache 
MiB Swap:      0.0 total,      0.0 free,      0.0 used.   5986.0 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+
     38 root      20   0    2672   1928   1820 R 100.0   0.0   0:03.83
      1 root      20   0    1032    744    696 S   0.0   0.0   0:00.02
      7 root      20   0    2580   1616   1512 S   0.0   0.0   0:00.00
```

## Get the PID with pgrep

```console
$ pgrep -a busy
38 /bin/sh /usr/local/bin/busy
```

```console
$ pgrep -x busy
38
```

## Stop it politely: kill sends SIGTERM

```console
$ kill $(pgrep -x busy); sleep 0.5; pgrep -a busy || echo "busy is gone"
busy is gone
```

```console
$ ls /tmp/worker.lock
/tmp/worker.lock
```

```console
$ pkill -f worker.sh; sleep 1.5; cat worker.log; ls /tmp/worker.lock 2>/dev/null || echo "lock file removed"
cleaning up
lock file removed
```

## Why kill -9 is the last resort

```console
$ (setsid ./worker.sh > worker.log 2>&1 &); sleep 1; pgrep -af worker.sh
121 /bin/bash ./worker.sh
```

```console
$ kill -9 $(pgrep -f worker.sh); sleep 1; cat worker.log; ls /tmp/worker.lock && echo "stale lock left behind"
/tmp/worker.lock
stale lock left behind
```

## pkill: preview with pgrep first

```console
$ rm -f /tmp/worker.lock; (setsid ./worker.sh >/dev/null 2>&1 &); sleep 1; pgrep -af work
146 /bin/bash ./worker.sh
```

```console
$ pkill -f work; sleep 1.5; pgrep -af work || echo "no worker left"
no worker left
```

## Quick check

**Question 1.** Which signal lets a program clean up before it exits: SIGTERM or SIGKILL?

**Answer:** SIGTERM (plain kill) — SIGTERM can be caught, so the program can save and tidy up. SIGKILL stops it instantly.

**Question 2.** Which command lists processes with the highest CPU use first?

**Answer:** ps aux --sort=-%cpu | head — The minus sign sorts from highest to lowest. Plain ps aux is sorted by process I D.

Commands that check the answers (run in the same container, after the lesson):

```console
$ (setsid ./worker.sh > quiz.log 2>&1 &); sleep 1; pkill -f worker.sh; sleep 1.5; cat quiz.log
cleaning up
```

```console
$ (setsid busy >/dev/null 2>&1 &); sleep 1; ps -eo pid,%cpu,comm --sort=-%cpu | head -2; pkill -x busy
    PID %CPU COMMAND
    180  100 busy
```

## Files

- `setup.sh` — demo folder
- `ps-top-kill.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
