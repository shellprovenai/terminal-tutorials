# Partitions and /etc/fstab without breaking boot: lsblk, UUIDs, nofail and findmnt --verify

> 🎬 Video: https://youtu.be/nH99IBoLx-I (public from Dec 9, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## See disks and partitions: lsblk

```console
$ lsblk -o NAME,SIZE,TYPE
NAME     SIZE TYPE
vda       60G disk
|-vda1  59.9G part
|-vda14    3M part
`-vda15  124M part
```

## Practise partitioning on an image file

```console
$ truncate -s 300M disk.img && ls -lh disk.img
-rw-r--r-- 1 root root 300M Nov 22 01:05 disk.img
```

```console
$ printf 'label: gpt\n,100M,L\n,,L\n' | sfdisk -q disk.img && sfdisk -l disk.img | tail -3
Device      Start    End Sectors  Size Type
disk.img1    2048 206847  204800  100M Linux filesystem
disk.img2  206848 612351  405504  198M Linux filesystem
```

## A file system and its UUID

```console
$ for n in data backup; do truncate -s 64M $n.img && mkfs.ext4 -q -F -L $n $n.img; done && blkid data.img backup.img
data.img: LABEL="data" UUID="f2a66116-59af-44d2-9788-eb37bfdc2763" BLOCK_SIZE="1024" TYPE="ext4"
backup.img: LABEL="backup" UUID="2f60b910-9797-4f14-bed0-7d7c85ab7c29" BLOCK_SIZE="1024" TYPE="ext4"
```

## The fstab line

```console
$ mkdir -p /mnt/data /mnt/backup && printf 'UUID=%s /mnt/data ext4 defaults 0 2\nUUID=1234-dead /mnt/backup ext4 defaults 0 2\n' "$(blkid -s UUID -o value data.img)" > fstab.test && cat fstab.test
UUID=f2a66116-59af-44d2-9788-eb37bfdc2763 /mnt/data ext4 defaults 0 2
UUID=1234-dead /mnt/backup ext4 defaults 0 2
```

## Check it before you reboot: findmnt --verify

```console
$ findmnt --verify --tab-file fstab.test

0 parse errors, 1 error, 1 warning
/mnt/data
   [W] non-bind mount source /lab/disk/data.img is a directory or regular file
/mnt/backup
   [E] unreachable on boot required source: UUID=1234-dead
```

```console
$ sed -i "s/UUID=1234-dead/UUID=$(blkid -s UUID -o value backup.img)/" fstab.test && findmnt --verify --tab-file fstab.test 2>&1 | head -1

```

## Quick check

**Question 1.** Why put UUID=... in /etc/fstab instead of /dev/sdb1?

**Answer:** Device names can change between boots, the UUID stays with the file system — If disks are added or reordered, s d b can become s d c. The U U I D is stored in the file system itself.

**Question 2.** How do I check /etc/fstab for mistakes before rebooting?

**Answer:** sudo findmnt --verify, then sudo mount -a — findmnt --verify finds bad U U I Ds and options without mounting. Mount dash a then tries every entry.

Commands that check the answers (run in the same container, after the lesson):

```console
$ blkid -s UUID -o value data.img
f2a66116-59af-44d2-9788-eb37bfdc2763
```

```console
$ printf 'UUID=1234-dead /mnt/backup ext4 defaults 0 2\n' > quiz.fstab && findmnt --verify --tab-file quiz.fstab 2>&1 | tail -1
   [E] unreachable on boot required source: UUID=1234-dead
```

## Files

- `setup.sh` — demo folder
- `fstab-safe.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
