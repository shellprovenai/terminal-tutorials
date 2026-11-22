# sort, uniq -c, cut and tr: the text toolbox for logs and CSV files (and their traps)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs sort-uniq-cut-tr.tape
Output sort-uniq-cut-tr.mp4
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
Type `mkdir -p /lab/text && cd /lab/text && clear`
Enter
Type `printf '10.0.0.5 GET /index.html 200\n10.0.0.7 GET /login 200\n10.0.0.5 POST /login 302\n10.0.0.9 GET /admin 404\n10.0.0.7 GET /api 500\n10.0.0.5 GET /missing 404\n10.0.0.9 GET /login 200\n10.0.0.5 GET /index.html 200\n' > access.log`
Enter
Type `printf 'id,city,amount\n1,Leeds,12\n2,lisbon,9\n3,Graz,120\n4,Leeds,30\n5,Lisbon,15\n6,graz,8\n' > orders.csv`
Enter
Type `clear`
Enter
Show

# --- cut: pick a column
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# cut: pick a column`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat access.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3349ms
Sleep 300ms
Type `cut -d ' ' -f1 access.log | head -4`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4366ms
Sleep 300ms
Type `cut -d, -f2 orders.csv`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4090ms

# --- Count values: sort | uniq -c
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Count values: sort | uniq -c`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cut -d ' ' -f1 access.log | uniq -c`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5442ms
Sleep 300ms
Type `cut -d ' ' -f1 access.log | sort | uniq -c`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9486ms
Sleep 300ms
Type `cut -d ' ' -f1 access.log | sort | uniq -c | sort -rn`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3981ms
Sleep 300ms
Type `cut -d ' ' -f4 access.log | sort | uniq -c | sort -rn`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3128ms

# --- tr: clean up before counting
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# tr: clean up before counting`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `tail -n +2 orders.csv | cut -d, -f2 | sort | uniq -c`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5322ms
Sleep 300ms
Type `tail -n +2 orders.csv | cut -d, -f2 | tr 'A-Z' 'a-z' | sort | uniq -c | sort -rn`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1920ms

# --- The trap: repeated spaces
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: repeated spaces`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `printf 'alice    12  Leeds\nbob      7   Graz\n' > aligned.txt && cut -d ' ' -f2 aligned.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4085ms
Sleep 300ms
Type `tr -s ' ' < aligned.txt | cut -d ' ' -f2`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8447ms

# --- Sort numbers correctly
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Sort numbers correctly`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `tail -n +2 orders.csv | sort -t, -k3`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5535ms
Sleep 300ms
Type `tail -n +2 orders.csv | sort -t, -k3 -n`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8375ms
Sleep 17185ms
