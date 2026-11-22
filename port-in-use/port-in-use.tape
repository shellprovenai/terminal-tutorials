# "Address already in use": find which process holds a port (ss, lsof, fuser) and free it
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs port-in-use.tape
Output port-in-use.mp4
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
Type `mkdir -p /lab/net && cd /lab/net && clear`
Enter
Type `(setsid socat TCP-LISTEN:8080,fork SYSTEM:'echo hello' >/dev/null 2>&1 &); sleep 1`
Enter
Type `clear`
Enter
Show

# --- The error
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The error`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `socat TCP-LISTEN:8080 -`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8866ms
Sleep 8950ms

# --- ss: who is listening
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# ss: who is listening`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ss -ltnp`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8832ms
Sleep 300ms
Type `ss -ltnp 'sport = :8080'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6555ms
Sleep 9170ms

# --- lsof and fuser
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# lsof and fuser`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `lsof -i :8080`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9207ms
Sleep 300ms
Type `fuser 8080/tcp`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3755ms
Sleep 300ms
Type `lsof -t -i :8080`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5296ms

# --- Free the port with kill
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Free the port with kill`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `kill $(lsof -t -i :8080); sleep 0.5; ss -ltn 'sport = :8080'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1952ms
Sleep 300ms
Type `(setsid socat TCP-LISTEN:8080,fork SYSTEM:'echo hello' >/dev/null 2>&1 &); sleep 1; ss -ltnp 'sport = :8080'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2335ms

# --- The trap: fuser -k sends SIGKILL
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: fuser -k sends SIGKILL`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 11212ms
Sleep 300ms
Type `kill $(lsof -t -i :8080); sleep 0.5; (setsid sh -c 'socat TCP-LISTEN:8080,fork SYSTEM:true >/dev/null 2>&1; echo "exit status $?" > /tmp/exit.txt' &); sleep 1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `fuser -k 8080/tcp; sleep 1; cat /tmp/exit.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 11026ms
Sleep 300ms
Type `(setsid sh -c 'socat TCP-LISTEN:8080,fork SYSTEM:true >/dev/null 2>&1; echo "exit status $?" > /tmp/exit.txt' &); sleep 1; fuser -k -TERM 8080/tcp; sleep 1; cat /tmp/exit.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 8700ms
