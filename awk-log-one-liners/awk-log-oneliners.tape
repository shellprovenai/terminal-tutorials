# awk for people who hate awk: 8 one-liners that answer real questions about a log
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs awk-log-oneliners.tape
Output awk-log-oneliners.mp4
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
Type `mkdir -p /lab/logs && cd /lab/logs && clear`
Enter
Type `printf '10.0.0.5 GET /index.html 200 5120 12\n10.0.0.7 GET /login 200 2048 30\n10.0.0.5 POST /login 302 512 45\n10.0.0.9 GET /admin 404 256 3\n10.0.0.7 GET /api/orders 500 128 950\n10.0.0.5 GET /missing.png 404 256 2\n10.0.0.9 GET /api/orders 200 8192 120\n10.0.0.7 GET /index.html 200 5120 10\n' > access.log`
Enter
Type `printf 'id,name,city\n1,Ana,Lisbon\n2,Tom,Leeds\n3,Mia,Graz\n' > users.csv`
Enter
Type `clear`
Enter
Show

# --- The log and the one idea
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The log and the one idea`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8890ms
Sleep 14177ms

# --- 1. Pick columns
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 1. Pick columns`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `awk '{print $1, $4}' access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4690ms
Sleep 7463ms

# --- 2. Filter lines with a condition
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 2. Filter lines with a condition`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `awk '$4 >= 400' access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6149ms
Sleep 8429ms
Sleep 300ms
Type `awk '$4 == 404 {print $3}' access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2365ms

# --- 3. Sum and average
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 3. Sum and average`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `awk '{sum += $5} END {print sum, "bytes"}' access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4594ms
Sleep 300ms
Type `awk '{t += $6; n++} END {printf "avg %.1f ms over %d requests\n", t/n, n}' access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4401ms

# --- 4. Count per value
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 4. Count per value`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `awk '{c[$1]++} END {for (ip in c) print c[ip], ip}' access.log | sort -rn`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3906ms
Sleep 8508ms

# --- 5. Other separators and the last field
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 5. Other separators and the last field`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `awk -F, 'NR > 1 {print $2 " lives in " $3}' users.csv`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8988ms
Sleep 300ms
Type `awk '$NF > 100 {print $NF " ms", $3}' access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9231ms
Sleep 5293ms

# --- The double-quote trap
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The double-quote trap`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `awk "{print $1}" access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5170ms
Sleep 15372ms
Sleep 3778ms
