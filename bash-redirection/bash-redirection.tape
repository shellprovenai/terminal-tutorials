# Bash redirection explained: >, >>, 2>, 2>&1 and | (and why the order matters)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs bash-redirection.tape
Output bash-redirection.mp4
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
Type `mkdir -p /lab/io && cd /lab/io && clear`
Enter
Type `mkdir logs && echo ok > logs/a.log`
Enter
Type `clear`
Enter
Show

# --- Two output streams
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Two output streams`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls logs missing`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6531ms
Sleep 12193ms

# --- > sends stdout to a file
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# > sends stdout to a file`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls logs missing > out.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1822ms
Sleep 300ms
Type `cat out.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5384ms
Sleep 6503ms

# --- 2> sends stderr to a file
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 2> sends stderr to a file`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls logs missing 2> err.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2784ms
Sleep 300ms
Type `cat err.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `ls logs missing 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 10717ms

# --- 2>&1: both streams into one file
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# 2>&1: both streams into one file`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls logs missing > all.txt 2>&1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9317ms
Sleep 300ms
Type `cat all.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 7804ms
Sleep 300ms
Type `ls logs missing 2>&1 > wrong.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2416ms
Sleep 300ms
Type `cat wrong.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 15660ms
Sleep 4888ms

# --- > overwrites, >> appends
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# > overwrites, >> appends`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `echo first > notes.txt && echo second > notes.txt && cat notes.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1882ms
Sleep 300ms
Type `echo third >> notes.txt && cat notes.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2495ms
Sleep 300ms
Type `set -o noclobber && echo oops > notes.txt`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 12156ms
Sleep 300ms
Type `set +o noclobber`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms

# --- Pipes only carry stdout
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Pipes only carry stdout`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls logs missing | wc -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5778ms
Sleep 300ms
Type `ls logs missing 2>&1 | wc -l`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8992ms

# --- tee: save it and see it
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# tee: save it and see it`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls logs missing 2>&1 | tee run.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6490ms
Sleep 300ms
Type `cat run.log`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 4354ms
