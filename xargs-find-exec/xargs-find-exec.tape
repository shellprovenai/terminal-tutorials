# xargs and find -exec done right: spaces in file names, -print0, and parallel jobs
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs xargs-find-exec.tape
Output xargs-find-exec.mp4
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
Type `mkdir -p /lab/files && cd /lab/files && clear`
Enter
Type `mkdir -p logs && printf 'one\ntwo\n' > "My Report.txt" && printf 'a\nb\nc\n' > notes.txt && printf 'x\n' > "Q3 plan.txt"`
Enter
Type `for i in 1 2 3 4; do seq 1000 > "logs/app $i.log"; done && touch old1.tmp "old 2.tmp"`
Enter
Type `clear`
Enter
Show

# --- The space problem
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The space problem`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3781ms
Sleep 300ms
Type `find . -name '*.txt' | xargs wc -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2763ms
Sleep 9212ms

# --- The fix: -print0 and xargs -0
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The fix: -print0 and xargs -0`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -name '*.txt' -print0 | xargs -0 wc -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7842ms
Sleep 8295ms

# --- find -exec: \; or +
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# find -exec: \; or +`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 10001ms
Sleep 300ms
Type `find . -name '*.txt' -exec echo run {} \;`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2739ms
Sleep 300ms
Type `find . -name '*.txt' -exec echo run {} +`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6698ms

# --- Preview before you delete
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Preview before you delete`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -name '*.tmp' -print0 | xargs -0 echo rm --`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4421ms
Sleep 300ms
Type `find . -name '*.tmp' -print0 | xargs -0 rm -- && ls`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8663ms

# --- Parallel jobs with xargs -P
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Parallel jobs with xargs -P`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `time (printf '1\n1\n1\n1\n' | xargs -n 1 sleep)`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5266ms
Sleep 300ms
Type `time (printf '1\n1\n1\n1\n' | xargs -n 1 -P 4 sleep)`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3509ms
Sleep 300ms
Type `find logs -name '*.log' -print0 | xargs -0 -n 1 -P 4 gzip && ls logs`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5337ms
Sleep 9447ms
