# Find files changed in the last 24 hours (and the -mtime +1 trap)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs find-changed-24h.tape
Output find-changed-24h.mp4
Set Shell "bash"
Set FontFamily "Noto Sans Mono"
Set FontSize 34
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
Type `mkdir -p /lab/project && cd /lab/project && clear`
Enter
Type `mkdir -p src logs node_modules/pkg`
Enter
Type `for f in src/app.py logs/app.log src/config.yaml src/utils.py README.md src/old_notes.txt LICENSE node_modules/pkg/index.js; do echo demo > "$f"; done`
Enter
Type `touch -d "10 minutes ago" src/app.py; touch -d "3 hours ago" logs/app.log; touch -d "20 hours ago" src/config.yaml`
Enter
Type `touch -d "30 hours ago" src/utils.py; touch -d "47 hours ago" README.md; touch -d "50 hours ago" src/old_notes.txt`
Enter
Type `touch -d "5 days ago" LICENSE; touch -d "1 hour ago" node_modules/pkg/index.js`
Enter
Type `clear`
Enter
Show

# --- The demo folder
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The demo folder`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -type f -printf '%TY-%Tm-%Td %TH:%TM  %p\n' | sort`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7213ms
Sleep 11062ms

# --- Modified in the last 24 hours: -mtime -1
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Modified in the last 24 hours: -mtime -1`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -type f -mtime -1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3888ms
Sleep 12854ms
Sleep 7420ms

# --- The trap: -mtime 1 and -mtime +1
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: -mtime 1 and -mtime +1`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -type f -mtime 1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2919ms
Sleep 7932ms
Sleep 300ms
Type `find . -type f -mtime +1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3050ms
Sleep 5820ms
Sleep 13729ms
Sleep 3821ms

# --- Exact times with -mmin
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Exact times with -mmin`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -type f -mmin -120`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4888ms
Sleep 12562ms

# --- Human-readable dates with -newermt
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Human-readable dates with -newermt`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -type f -newermt '6 hours ago'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4520ms
Sleep 300ms
Type `find . -type f -newermt '2000-01-01' | wc -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5130ms
Sleep 300ms
Type `find . -type f -newermt '2 days ago' ! -newermt '1 day ago'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6109ms

# --- Skipping folders with -prune
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Skipping folders with -prune`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -path ./node_modules -prune -o -type f -mmin -1440`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3885ms
Sleep 10279ms
Sleep 300ms
Type `find . -path ./node_modules -prune -o -type f -mmin -1440 -print`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2821ms
Sleep 4391ms

# --- Show when each file changed
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Show when each file changed`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -path ./node_modules -prune -o -type f -mmin -1440 -printf '%TY-%Tm-%Td %TH:%TM  %p\n' | sort`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4896ms
Sleep 7868ms

# --- Back up today's changes safely
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Back up today's changes safely`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 4760ms
Sleep 300ms
Type `find . -path ./node_modules -prune -o -type f -mmin -1440 -print0 | tar --null -T - -czf /tmp/recent.tgz`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7274ms
Sleep 300ms
Type `tar -tzvf /tmp/recent.tgz`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `find . -path ./node_modules -prune -o -type f -mmin -1440 -exec ls -l {} +`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7343ms
