# SSH keys from scratch: generate, install, shortcut with ~/.ssh/config, turn off passwords
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs ssh-keys.tape
Output ssh-keys.mp4
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
Type `mkdir -p /lab && cd /lab && clear`
Enter
Type `useradd -m -s /bin/bash deploy && mkdir -p /run/sshd && /usr/sbin/sshd`
Enter
Type `clear`
Enter
Show

# --- 1. Generate a key
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 1. Generate a key`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ssh-keygen -t ed25519 -C "laptop" -f ~/.ssh/id_ed25519 -N ""`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9668ms
Sleep 300ms
Type `ls -l ~/.ssh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10037ms
Sleep 13104ms

# --- 2. Install the public key on the server
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 2. Install the public key on the server`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 11809ms
Sleep 300ms
Type `install -d -m 700 -o deploy -g deploy /home/deploy/.ssh && install -m 600 -o deploy -g deploy ~/.ssh/id_ed25519.pub /home/deploy/.ssh/authorized_keys`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5822ms
Sleep 300ms
Type `ssh -o StrictHostKeyChecking=accept-new deploy@localhost whoami`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10252ms
Sleep 2882ms

# --- 3. Why key login suddenly stops working
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 3. Why key login suddenly stops working`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chmod 777 /home/deploy && ssh -o BatchMode=yes deploy@localhost whoami`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8805ms
Sleep 15798ms
Sleep 300ms
Type `chmod 700 /home/deploy && ssh -o BatchMode=yes deploy@localhost whoami`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6224ms
Sleep 9298ms

# --- 4. A shortcut in ~/.ssh/config
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 4. A shortcut in ~/.ssh/config`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `printf 'Host web\n    HostName localhost\n    User deploy\n    IdentityFile ~/.ssh/id_ed25519\n' > ~/.ssh/config && chmod 600 ~/.ssh/config`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3378ms
Sleep 300ms
Type `cat ~/.ssh/config`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `ssh web 'whoami; hostname'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6134ms
Sleep 7079ms

# --- 5. Turn off password logins
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 5. Turn off password logins`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sshd -T | grep -i '^passwordauthentication'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4423ms
Sleep 9788ms
Sleep 300ms
Type `echo 'PasswordAuthentication no' > /etc/ssh/sshd_config.d/10-no-passwords.conf && sshd -t && echo config OK`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7843ms
Sleep 300ms
Type `kill -HUP "$(cat /run/sshd.pid)" && sleep 1 && sshd -T | grep -i '^passwordauthentication'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 8508ms
Sleep 300ms
Type `ssh -o PubkeyAuthentication=no -o BatchMode=yes deploy@localhost true`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `ssh web 'echo key login still works'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2655ms
