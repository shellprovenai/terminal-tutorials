# Linux file permissions: read ls -l, fix "Permission denied", and never chmod 777
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs linux-permissions.tape
Output linux-permissions.mp4
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
Type `mkdir -p /lab/site && cd /lab/site && clear`
Enter
Type `useradd -m alice && useradd -m bob && groupadd web && usermod -aG web alice`
Enter
Type `echo hello > index.html && printf '#!/bin/sh\necho deployed\n' > deploy.sh && echo DB_PASSWORD=demo > secret.env`
Enter
Type `mkdir private && echo x > private/notes.txt && chown -R alice:web /lab/site`
Enter
Type `clear`
Enter
Show

# --- Reading ls -l
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Reading ls -l`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10268ms
Sleep 12022ms
Sleep 7548ms
Sleep 7277ms

# --- From letters to numbers
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# From letters to numbers`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `stat -c '%A %a %U:%G %n' *`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7316ms
Sleep 12860ms
Sleep 11345ms

# --- Problem 1: the script won't run
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Problem 1: the script won't run`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `su alice -c ./deploy.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 6332ms
Sleep 300ms
Type `chmod u+x deploy.sh && su alice -c ./deploy.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3926ms
Sleep 300ms
Type `chmod go-w,g+x deploy.sh && stat -c '%A %a %n' deploy.sh`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5077ms

# --- Problem 2: a secret anyone can read
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Problem 2: a secret anyone can read`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `su bob -c 'cat secret.env'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3333ms
Sleep 300ms
Type `chmod 600 secret.env && su bob -c 'cat secret.env'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6548ms
Sleep 4034ms

# --- Problem 3: a private folder
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Problem 3: a private folder`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chmod 750 private && su bob -c 'ls private'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8840ms
Sleep 300ms
Type `ls -ld private`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 7768ms

# --- Why chmod 777 is a bad fix
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Why chmod 777 is a bad fix`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chmod 777 index.html && su bob -c 'echo defaced > index.html' && cat index.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8012ms
Sleep 12854ms
Sleep 300ms
Type `find . -perm -o=w -type f`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3784ms
Sleep 300ms
Type `chmod 644 index.html && su bob -c 'echo again > index.html'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms

# --- Changing the owner with chown
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Changing the owner with chown`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chown bob:web index.html && ls -l index.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7968ms
Sleep 7362ms
