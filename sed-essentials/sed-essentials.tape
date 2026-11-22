# sed for the three things you actually need: replace in place, delete lines, print a range
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs sed-essentials.tape
Output sed-essentials.mp4
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
Type `mkdir -p /lab/sed && cd /lab/sed && clear`
Enter
Type `printf '# app settings\nhost=localhost\nport=8080\nadmin_port=8080\n\n# links\nurl=http://localhost:8080/health?port=8080#start\ndebug=true\n' > app.conf`
Enter
Type `for i in $(seq 1 30); do echo "2026-11-20 10:00:$i INFO request $i"; done > app.log && sed -i '12s/INFO/ERROR/; 21s/INFO/ERROR/' app.log`
Enter
Type `sed -i '15i --- START deploy' app.log && sed -i '18i --- END deploy' app.log`
Enter
Type `clear`
Enter
Show

# --- Replace: s/old/new/
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Replace: s/old/new/`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `sed 's/8080/9090/' app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5938ms
Sleep 300ms
Type `sed 's/8080/9090/g' app.conf | grep 9090`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10063ms
Sleep 300ms
Type `grep 8080 app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms

# --- Edit in place, with a backup
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Edit in place, with a backup`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sed -i.bak 's/^port=8080/port=9090/' app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8909ms
Sleep 300ms
Type `diff app.conf.bak app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 8636ms

# --- The trap: -i without a backup
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: -i without a backup`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sed -i '/#/d' app.conf && cat app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7434ms
Sleep 10300ms
Sleep 300ms
Type `cp app.conf.bak app.conf && sed -i 's/^port=8080/port=9090/' app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2786ms
Sleep 300ms
Type `sed '/^#/d' app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10415ms

# --- Delete lines
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Delete lines`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sed '/^#/d; /^$/d' app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7788ms
Sleep 300ms
Type `sed '2d; $d' app.conf`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5922ms

# --- Print a range
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Print a range`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sed -n '10,15p' app.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9740ms
Sleep 300ms
Type `sed -n '/ERROR/p' app.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2136ms
Sleep 300ms
Type `sed -n '/START/,/END/p' app.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5699ms
Sleep 300ms
Type `echo "root=/var/www/html" | sed 's|/var/www|/srv/www|'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8229ms
