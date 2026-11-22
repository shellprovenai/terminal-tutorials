# Write a USB image with dd and verify it: checksums, pv, and the "wrong device" danger
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs dd-verify-image.tape
Output dd-verify-image.mp4
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
Type `mkdir -p /lab/usb && cd /lab/usb && clear`
Enter
Type `head -c 48M /dev/urandom > distro.iso && sha256sum distro.iso > SHA256SUMS`
Enter
Type `clear`
Enter
Show

# --- Verify the download
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Verify the download`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `ls -lh distro.iso && cat SHA256SUMS`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3896ms
Sleep 300ms
Type `sha256sum -c SHA256SUMS`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8829ms
Sleep 8060ms

# --- Find the right device
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Find the right device`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `lsblk -o NAME,SIZE,TYPE`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9271ms
Sleep 300ms
Type `truncate -s 128M usb.img && ls -lh usb.img`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 18404ms

# --- Write with dd
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Write with dd`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `dd if=distro.iso of=usb.img bs=4M conv=fsync,notrunc status=progress`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 11012ms
Sleep 23457ms

# --- Progress with pv
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Progress with pv`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `pv distro.iso > copy.img && ls -lh copy.img`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6898ms
Sleep 7554ms

# --- Verify the written copy
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Verify the written copy`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sha256sum distro.iso usb.img`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3573ms
Sleep 300ms
Type `head -c "$(stat -c %s distro.iso)" usb.img | sha256sum && cut -d ' ' -f1 SHA256SUMS`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6572ms
Sleep 300ms
Type `cmp -n "$(stat -c %s distro.iso)" distro.iso usb.img && echo "identical"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5519ms
