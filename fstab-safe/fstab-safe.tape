# Partitions and /etc/fstab without breaking boot: lsblk, UUIDs, nofail and findmnt --verify
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs fstab-safe.tape
Output fstab-safe.mp4
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
Type `mkdir -p /lab/disk && cd /lab/disk && clear`
Enter
Type `clear`
Enter
Show

# --- See disks and partitions: lsblk
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# See disks and partitions: lsblk`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `lsblk -o NAME,SIZE,TYPE`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7762ms
Sleep 14497ms

# --- Practise partitioning on an image file
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Practise partitioning on an image file`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `truncate -s 300M disk.img && ls -lh disk.img`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3878ms
Sleep 300ms
Type `printf 'label: gpt\n,100M,L\n,,L\n' | sfdisk -q disk.img && sfdisk -l disk.img | tail -3`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 12949ms
Sleep 5713ms

# --- A file system and its UUID
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# A file system and its UUID`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `for n in data backup; do truncate -s 64M $n.img && mkfs.ext4 -q -F -L $n $n.img; done && blkid data.img backup.img`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7359ms
Sleep 24262ms

# --- The fstab line
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The fstab line`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `mkdir -p /mnt/data /mnt/backup && printf 'UUID=%s /mnt/data ext4 defaults 0 2\nUUID=1234-dead /mnt/backup ext4 defaults 0 2\n' "$(blkid -s UUID -o value data.img)" > fstab.test && cat fstab.test`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 7231ms
Sleep 9532ms

# --- Check it before you reboot: findmnt --verify
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Check it before you reboot: findmnt --verify`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `findmnt --verify --tab-file fstab.test`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6117ms
Sleep 19809ms
Sleep 300ms
Type `sed -i "s/UUID=1234-dead/UUID=$(blkid -s UUID -o value backup.img)/" fstab.test && findmnt --verify --tab-file fstab.test 2>&1 | head -1`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 16033ms
Sleep 15143ms
