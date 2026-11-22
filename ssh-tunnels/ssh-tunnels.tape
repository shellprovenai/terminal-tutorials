# SSH tunnels for your own server: -L, -R and -D, reach a database that only listens on localhost
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs ssh-tunnels.tape
Output ssh-tunnels.mp4
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
Type `useradd -m -s /bin/bash deploy && mkdir -p /run/sshd && /usr/sbin/sshd`
Enter
Type `ssh-keygen -q -t ed25519 -f ~/.ssh/id_ed25519 -N "" && install -d -m 700 -o deploy -g deploy /home/deploy/.ssh && install -m 600 -o deploy -g deploy ~/.ssh/id_ed25519.pub /home/deploy/.ssh/authorized_keys`
Enter
Type `ssh -q -o StrictHostKeyChecking=accept-new deploy@localhost true`
Enter
Type `(setsid socat TCP-LISTEN:5432,bind=127.0.0.1,fork SYSTEM:'echo "db: hello from port 5432"' >/dev/null 2>&1 &); sleep 1`
Enter
Type `mkdir -p /tmp/site && echo "preview of my local app" > /tmp/site/index.html && (setsid python3 -m http.server 8000 --bind 127.0.0.1 --directory /tmp/site >/dev/null 2>&1 &); sleep 1`
Enter
Type `clear`
Enter
Show

# --- A service that only listens on localhost
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# A service that only listens on localhost`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ss -ltn 'sport = :5432'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9192ms
Sleep 9298ms

# --- Local forward: ssh -L
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Local forward: ssh -L`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 17426ms
Sleep 300ms
Type `ssh -f -N -L 15432:localhost:5432 deploy@localhost && ss -ltn 'sport = :15432'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5163ms
Sleep 300ms
Type `socat - TCP:localhost:15432`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5106ms
Sleep 300ms
Type `pkill -f "ssh -f -N -L 15432" && sleep 0.5; ss -ltn 'sport = :15432'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8010ms

# --- Reverse forward: ssh -R
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Reverse forward: ssh -R`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ssh -f -N -R 9000:localhost:8000 deploy@localhost && curl -s http://localhost:9000/`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8968ms
Sleep 300ms
Type `ss -ltn 'sport = :9000'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3901ms
Sleep 300ms
Type `pkill -f "ssh -f -N -R 9000"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 11994ms

# --- SOCKS proxy: ssh -D
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# SOCKS proxy: ssh -D`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ssh -f -N -D 1080 deploy@localhost && curl -s --socks5-hostname localhost:1080 http://localhost:8000/`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8818ms
Sleep 300ms
Type `pkill -f "ssh -f -N -D 1080"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9802ms

# --- Make it permanent: LocalForward in ~/.ssh/config
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Make it permanent: LocalForward in ~/.ssh/config`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `printf 'Host db-tunnel\n    HostName localhost\n    User deploy\n    LocalForward 15432 localhost:5432\n' >> ~/.ssh/config && chmod 600 ~/.ssh/config && cat ~/.ssh/config`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `ssh -f -N db-tunnel && socat - TCP:localhost:15432`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 12626ms
