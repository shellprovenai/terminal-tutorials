# Cron job not running? It works in the terminal, here's why it fails in cron
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs cron-debug.tape
Output cron-debug.mp4
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
Type `mkdir -p /lab/jobs && cd /lab/jobs && clear`
Enter
Type `printf '#!/bin/sh\necho "report for $(hostname): 42 orders"\n' > /usr/local/bin/report-tool && chmod +x /usr/local/bin/report-tool`
Enter
Type `printf '#!/bin/sh\nreport-tool > report.txt\necho "saved report"\n' > backup.sh && chmod +x backup.sh && cron`
Enter
Type `printf '# min hour day month weekday  command\n* * * * * /lab/jobs/backup.sh >> /tmp/backup.log 2>&1\n* * * * * env > /tmp/cron-env.txt\n' > first.cron`
Enter
Type `for i in $(seq 90); do [ -s /tmp/cron-env.txt ] && break; sleep 2; done; sleep 2`
Enter
Type `printf 'PATH=/usr/local/bin:/usr/bin:/bin\n# min hour day month weekday  command\n* * * * * cd /lab/jobs && ./backup.sh >> /tmp/backup.log 2>&1\n* * * * * echo "ran at $(date +%%H:%%M)" >> /tmp/broken.log\n* * * * * echo "ran at $(date +\\%%H:\\%%M)" >> /tmp/fixed.log\n' > fixed.cron`
Enter
Type `for i in $(seq 90); do [ -s /tmp/fixed.log ] && break; sleep 2; done; sleep 2`
Enter
Type `clear`
Enter
Show

# --- A script that works
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# A script that works`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat backup.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6072ms
Sleep 300ms
Type `./backup.sh && cat report.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 8423ms

# --- Schedule it, and log the output
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Schedule it, and log the output`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat first.cron`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9716ms
Sleep 16246ms
Sleep 300ms
Type `crontab first.cron && crontab -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4479ms

# --- Why it fails
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Why it fails`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat /tmp/backup.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3442ms
Sleep 10742ms
Sleep 300ms
Type `cat /tmp/cron-env.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5346ms
Sleep 12086ms
Sleep 300ms
Type `ls /root`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9877ms

# --- The fix: PATH and cd in the crontab
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The fix: PATH and cd in the crontab`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat fixed.cron`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9140ms
Sleep 300ms
Type `crontab fixed.cron`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6512ms

# --- Check it
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Check it`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `tail -n 1 /tmp/backup.log && cat report.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 5912ms

# --- The percent-sign trap
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The percent-sign trap`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat /tmp/broken.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3549ms
Sleep 9404ms
Sleep 300ms
Type `cat /tmp/fixed.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2742ms
Sleep 9304ms
