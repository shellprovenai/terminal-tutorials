# systemctl and journalctl for people who only need five commands: status, logs, follow, enable
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs systemctl-journalctl.tape
Output systemctl-journalctl.mp4
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
Type `printf '#!/bin/sh\necho "hello-app starting"\nwhile true; do echo "tick $(date +%%T)"; sleep 2; done\n' > /usr/local/bin/hello-app && chmod +x /usr/local/bin/hello-app`
Enter
Type `printf '[Unit]\nDescription=Hello demo app\n\n[Service]\nExecStart=/usr/local/bin/hello-app\n\n[Install]\nWantedBy=multi-user.target\n' > /etc/systemd/system/hello-app.service`
Enter
Type `printf '[Unit]\nDescription=Report job (broken on purpose)\n\n[Service]\nType=oneshot\nExecStart=/usr/local/bin/report-tool\n' > /etc/systemd/system/report.service`
Enter
Type `systemctl daemon-reload`
Enter
Type `clear`
Enter
Show

# --- 1. systemctl status
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 1. systemctl status`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemctl start hello-app && sleep 3 && systemctl status hello-app --no-pager -n 2`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4074ms
Sleep 12540ms

# --- 2. Why did it fail? journalctl -u
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 2. Why did it fail? journalctl -u`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemctl start report`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3002ms
Sleep 300ms
Type `journalctl -u report --no-pager -n 5`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7520ms
Sleep 300ms
Type `systemctl status report --no-pager`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4890ms
Sleep 6530ms

# --- 3. Logs since boot, or the last minutes
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 3. Logs since boot, or the last minutes`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `journalctl -b -u hello-app --no-pager | head -4`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4605ms
Sleep 300ms
Type `journalctl --since "10 min ago" -p err --no-pager`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6360ms

# --- 4. Follow logs live
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 4. Follow logs live`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `timeout 5 journalctl -u hello-app -f --no-pager -n 1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8586ms
Sleep 7335ms

# --- 5. start vs enable
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 5. start vs enable`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `systemctl is-enabled hello-app`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4410ms
Sleep 300ms
Type `systemctl stop hello-app && systemctl enable hello-app`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6233ms
Sleep 300ms
Type `systemctl is-active hello-app`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `systemctl enable --now hello-app && systemctl is-active hello-app && systemctl is-enabled hello-app`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3500ms
