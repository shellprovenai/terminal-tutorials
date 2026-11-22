# tar and gzip without the usual mistakes: back up a folder, skip the junk, verify the archive
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs tar-gzip-backup.tape
Output tar-gzip-backup.mp4
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
Type `mkdir -p /lab/work && cd /lab/work && clear`
Enter
Type `mkdir -p project/src project/node_modules/lib project/logs`
Enter
Type `printf 'print("hello")\n' > project/src/app.py && printf 'debug = false\n' > project/src/config.ini && printf '# Demo project\n' > project/README.md`
Enter
Type `head -c 6M /dev/urandom > project/node_modules/lib/bundle.bin && head -c 2M /dev/urandom > project/logs/app.log`
Enter
Type `clear`
Enter
Show

# --- The project folder
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The project folder`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `find project -type f | sort`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5789ms
Sleep 300ms
Type `du -sh project`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 6210ms

# --- Create an archive and look inside
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Create an archive and look inside`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `tar -czf backup.tgz project`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7794ms
Sleep 300ms
Type `ls -lh backup.tgz`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `tar -tzf backup.tgz`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5298ms
Sleep 7996ms

# --- The trap: absolute paths
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: absolute paths`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `tar -czf abs.tgz /lab/work/project`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4122ms
Sleep 300ms
Type `tar -tzf abs.tgz | head -3`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5423ms
Sleep 300ms
Type `mkdir /tmp/restore && tar -xzf abs.tgz -C /tmp/restore && find /tmp/restore -maxdepth 3 -type d`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3922ms
Sleep 7932ms
Sleep 300ms
Type `tar -czf good.tgz -C /lab/work project && tar -tzf good.tgz | head -3`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4200ms
Sleep 4973ms

# --- Skip the junk with --exclude
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Skip the junk with --exclude`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `tar -czf small.tgz --exclude=node_modules --exclude='*.log' -C /lab/work project`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4986ms
Sleep 300ms
Type `tar -tzf small.tgz`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `ls -lh good.tgz small.tgz`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6210ms
Sleep 6460ms

# --- Verify the backup
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Verify the backup`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `gzip -t small.tgz && echo "gzip OK"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4552ms
Sleep 300ms
Type `tar -dzf small.tgz -C /lab/work && echo "archive matches the disk"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6128ms
Sleep 300ms
Type `echo "debug = true" > project/src/config.ini && tar -dzf small.tgz -C /lab/work`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `printf 'debug = false\n' > project/src/config.ini && tar -czf small.tgz --exclude=node_modules --exclude='*.log' -C /lab/work project`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms

# --- Restore one file
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Restore one file`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `mkdir /tmp/one && tar -xzf small.tgz -C /tmp/one project/src/config.ini && find /tmp/one -type f`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3583ms
Sleep 9895ms
