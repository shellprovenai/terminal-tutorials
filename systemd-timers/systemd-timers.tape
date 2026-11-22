# systemd timers instead of cron: schedule a job, check the next run, read its logs
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs systemd-timers.tape
Output systemd-timers.mp4
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
Type `mkdir -p /root && cd /root && clear`
Enter
Type `printf '#!/bin/sh\necho "report generated at $(date +%%T)" >> /var/log/report.log\necho "report OK"\n' > /usr/local/bin/make-report && chmod +x /usr/local/bin/make-report`
Enter
Type `printf '[Unit]\nDescription=Generate the report\n\n[Service]\nType=oneshot\nExecStart=/usr/local/bin/make-report\n' > /etc/systemd/system/report.service`
Enter
Type `printf '[Unit]\nDescription=Run the report every 10 seconds (demo)\n\n[Timer]\nOnCalendar=*:*:0/10\nAccuracySec=1s\nPersistent=true\n\n[Install]\nWantedBy=timers.target\n' > /etc/systemd/system/report.timer`
Enter
Type `systemctl daemon-reload`
Enter
Type `clear`
Enter
Show

# --- A job as a oneshot service
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# A job as a oneshot service`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemctl cat report.service --no-pager`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6354ms
Sleep 300ms
Type `systemctl start report.service && journalctl -u report.service --no-pager -n 4`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms

# --- The timer
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The timer`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemctl cat report.timer --no-pager`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10262ms
Sleep 300ms
Type `systemctl enable --now report.timer`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3171ms

# --- When does it run next?
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# When does it run next?`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemctl list-timers report.timer --no-pager`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3176ms
Sleep 5677ms

# --- Every run is in the journal
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Every run is in the journal`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sleep 15; journalctl -u report.service --no-pager -n 6`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `tail -n 3 /var/log/report.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6263ms

# --- Test a schedule with systemd-analyze calendar
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Test a schedule with systemd-analyze calendar`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemd-analyze calendar "Mon..Fri 02:30" --iterations=3`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5589ms
Sleep 300ms
Type `systemd-analyze calendar daily`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4005ms
Sleep 11943ms

# --- The trap: edited timer, old schedule
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: edited timer, old schedule`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sed -i 's|0/10|0/30|' /etc/systemd/system/report.timer && systemctl restart report.timer 2>&1 | head -2`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `systemctl show report.timer -p TimersCalendar`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6050ms
Sleep 300ms
Type `systemctl daemon-reload && systemctl restart report.timer && systemctl show report.timer -p TimersCalendar`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 4888ms
