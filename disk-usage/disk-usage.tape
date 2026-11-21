# Disk full? Find what's eating your space with df, du and sort (Linux)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs disk-usage.tape
Output disk-usage.mp4
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
Type `mkdir -p /lab/srv && cd /lab/srv && clear`
Enter
Type `mkdir -p app/logs app/cache/thumbs backups uploads`
Enter
Type `fallocate -l 60M app/logs/app.log.1 && fallocate -l 8M app/logs/app.log && fallocate -l 24M app/cache/thumbs/blob.bin`
Enter
Type `fallocate -l 100M backups/db-2026-10.sql.gz && fallocate -l 104M backups/db-2026-11.sql.gz && fallocate -l 3M uploads/photo.jpg`
Enter
Type `clear`
Enter
Show

# --- Step 1: which filesystem is full? df -h
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 1: which filesystem is full? df -h`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `df -h /lab`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6021ms
Sleep 11623ms
Sleep 6689ms

# --- Step 2: which folder? du -sh
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 2: which folder? du -sh`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `du -sh *`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6080ms
Sleep 6887ms

# --- Step 3: drill down with --max-depth and sort -h
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 3: drill down with --max-depth and sort -h`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `du -h --max-depth=2 . | sort -h`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8707ms
Sleep 9255ms
Sleep 300ms
Type `du -ah . | sort -rh | head -6`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3539ms

# --- Step 4: list the big files with find
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 4: list the big files with find`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find . -type f -size +50M -exec ls -lh {} +`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5773ms
Sleep 9148ms

# --- Step 5: free space safely
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 5: free space safely`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `truncate -s 0 app/logs/app.log.1 && du -sh app`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7439ms
Sleep 9660ms

# --- The mystery: df says full, du disagrees
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The mystery: df says full, du disagrees`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `fallocate -l 200M big.tmp && du -sh .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3362ms
Sleep 300ms
Type `sleep 600 < big.tmp &`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5816ms
Sleep 300ms
Type `rm big.tmp && du -sh .`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1664ms
Sleep 10578ms
Sleep 300ms
Type `find /proc/*/fd -lname '*(deleted)' -printf '%p -> %l\n' 2>/dev/null`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2533ms
Sleep 300ms
Type `kill %1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6318ms
