# What's eating your CPU? Find it with ps and top, and stop it safely (SIGTERM vs SIGKILL)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs ps-top-kill.tape
Output ps-top-kill.mp4
Set Shell "bash"
Set FontFamily "Noto Sans Mono"
Set FontSize 38
Set LineHeight 1.25
Set Width 1920
Set Height 1080
Set Framerate 30
Set Padding 48
Set TypingSpeed 40ms
Set Theme "GitHub Dark"
Set WindowBar Colorful
Set CursorBlink false

Hide
Type `mkdir -p /lab/proc && cd /lab/proc && clear`
Enter
Type `printf '#!/bin/sh\nwhile :; do :; done\n' > /usr/local/bin/busy && chmod +x /usr/local/bin/busy`
Enter
Type `printf '#!/bin/bash\ntrap "echo cleaning up; rm -f /tmp/worker.lock; exit 0" TERM\ntouch /tmp/worker.lock\nwhile :; do sleep 1; done\n' > worker.sh && chmod +x worker.sh`
Enter
Type `(setsid busy >/dev/null 2>&1 &); (setsid ./worker.sh > worker.log 2>&1 &); sleep 2`
Enter
Type `clear`
Enter
Show

# --- Find the busy process: ps --sort
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Find the busy process: ps --sort`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 9090ms
Sleep 300ms
Type `ps aux --sort=-%cpu | head -4`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5730ms
Sleep 10087ms
Sleep 300ms
Type `ps -eo pid,rss,comm --sort=-rss | head -4`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5080ms

# --- top in one snapshot
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# top in one snapshot`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `top -b -n 1 -w 76 | head -10`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7669ms
Sleep 11373ms

# --- Get the PID with pgrep
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Get the PID with pgrep`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `pgrep -a busy`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7650ms
Sleep 300ms
Type `pgrep -x busy`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5630ms

# --- Stop it politely: kill sends SIGTERM
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Stop it politely: kill sends SIGTERM`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `kill $(pgrep -x busy); sleep 0.5; pgrep -a busy || echo "busy is gone"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3792ms
Sleep 300ms
Type `ls /tmp/worker.lock`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6956ms
Sleep 300ms
Type `pkill -f worker.sh; sleep 1.5; cat worker.log; ls /tmp/worker.lock 2>/dev/null || echo "lock file removed"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 5863ms

# --- Why kill -9 is the last resort
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Why kill -9 is the last resort`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `(setsid ./worker.sh > worker.log 2>&1 &); sleep 1; pgrep -af worker.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2304ms
Sleep 300ms
Type `kill -9 $(pgrep -f worker.sh); sleep 1; cat worker.log; ls /tmp/worker.lock && echo "stale lock left behind"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 11474ms
Sleep 12519ms

# --- pkill: preview with pgrep first
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# pkill: preview with pgrep first`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `rm -f /tmp/worker.lock; (setsid ./worker.sh >/dev/null 2>&1 &); sleep 1; pgrep -af work`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4898ms
Sleep 300ms
Type `pkill -f work; sleep 1.5; pgrep -af work || echo "no worker left"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8530ms
