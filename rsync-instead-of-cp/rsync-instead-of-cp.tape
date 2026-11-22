# rsync instead of cp: copy only what changed, dry-run first, and the trailing-slash trap
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs rsync-instead-of-cp.tape
Output rsync-instead-of-cp.mp4
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
Type `mkdir -p /lab/sync && cd /lab/sync && clear`
Enter
Type `mkdir -p photos/2026 photos/cache && for f in a b c; do head -c 300K /dev/urandom > photos/2026/$f.jpg; done`
Enter
Type `printf 'Trip notes\n' > photos/notes.txt && head -c 100K /dev/urandom > photos/cache/thumbs.tmp && printf 'old\n' > photos/old.txt`
Enter
Type `clear`
Enter
Show

# --- The first copy: rsync -a
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The first copy: rsync -a`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find photos -type f | sort`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4363ms
Sleep 300ms
Type `rsync -a photos/ backup/`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9919ms
Sleep 300ms
Type `find backup -type f | sort`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 2498ms

# --- Only what changed: -i
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Only what changed: -i`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `echo "Day 2: rain" >> photos/notes.txt && rsync -ai photos/ backup/`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5640ms
Sleep 12150ms
Sleep 300ms
Type `rsync -ai photos/ backup/ && echo "nothing to copy"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms

# --- Deletions: dry run first
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Deletions: dry run first`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `rm photos/old.txt && rsync -ai photos/ backup/ && ls backup`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4381ms
Sleep 13558ms
Sleep 300ms
Type `rsync -ain --delete photos/ backup/`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5533ms
Sleep 300ms
Type `ls backup`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `rsync -ai --delete photos/ backup/ && ls backup`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5373ms

# --- The trailing-slash trap
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trailing-slash trap`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `rsync -a photos/ copy1/ && ls copy1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5533ms
Sleep 300ms
Type `rsync -a photos copy2/ && ls copy2`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3083ms
Sleep 13963ms
Sleep 6567ms

# --- Skip files with --exclude
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Skip files with --exclude`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `rsync -ai --delete --exclude='*.tmp' --exclude=cache/ photos/ clean/`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5066ms
Sleep 300ms
Type `find clean -type f | sort`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 13116ms
