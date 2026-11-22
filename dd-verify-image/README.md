# Write a USB image with dd and verify it: checksums, pv, and the "wrong device" danger

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Verify the download

```console
$ ls -lh distro.iso && cat SHA256SUMS
-rw-r--r-- 1 root root 48M Nov 22 02:14 distro.iso
c16e1e91e014f55f87a0258ce37ff668c56ad1dcc553809df1f35ef6f27db15d  distro.iso
```

```console
$ sha256sum -c SHA256SUMS
distro.iso: OK
```

## Find the right device

```console
$ lsblk -o NAME,SIZE,TYPE
NAME     SIZE TYPE
vda       60G disk
|-vda1  59.9G part
|-vda14    3M part
`-vda15  124M part
```

```console
$ truncate -s 128M usb.img && ls -lh usb.img
-rw-r--r-- 1 root root 128M Nov 22 02:14 usb.img
```

## Write with dd

```console
$ dd if=distro.iso of=usb.img bs=4M conv=fsync,notrunc status=progress
12+0 records in
12+0 records out
50331648 bytes (50 MB, 48 MiB) copied, 0.471656 s, 107 MB/s
```

## Progress with pv

```console
$ pv distro.iso > copy.img && ls -lh copy.img
-rw-r--r-- 1 root root 48M Nov 22 02:14 copy.img
```

## Verify the written copy

```console
$ sha256sum distro.iso usb.img
c16e1e91e014f55f87a0258ce37ff668c56ad1dcc553809df1f35ef6f27db15d  distro.iso
f6a708c46e79ac6a551d78f52dfe9feb4009f747e738b8d5436ff5f1f37c1003  usb.img
```

```console
$ head -c "$(stat -c %s distro.iso)" usb.img | sha256sum && cut -d ' ' -f1 SHA256SUMS
c16e1e91e014f55f87a0258ce37ff668c56ad1dcc553809df1f35ef6f27db15d  -
c16e1e91e014f55f87a0258ce37ff668c56ad1dcc553809df1f35ef6f27db15d
```

```console
$ cmp -n "$(stat -c %s distro.iso)" distro.iso usb.img && echo "identical"
identical
```

## Quick check

**Question 1.** The SHA256 of my whole USB stick doesn't match the ISO checksum. Is the write broken?

**Answer:** Not necessarily. Checksum only the first (image size) bytes of the stick — The stick is bigger than the image. Use head dash c with the image size, or cmp -n.

**Question 2.** Before running dd of=/dev/sdX, how do I make sure X is the USB stick?

**Answer:** Run lsblk before and after plugging it in, and check the size — The device that appears, with the size of your stick, is the target. Anything else gets overwritten.

Commands that check the answers (run in the same container, after the lesson):

```console
$ head -c "$(stat -c %s distro.iso)" usb.img | sha256sum
c16e1e91e014f55f87a0258ce37ff668c56ad1dcc553809df1f35ef6f27db15d  -
```

```console
$ lsblk -o NAME,SIZE,TYPE | head -2
NAME     SIZE TYPE
vda       60G disk
```

## Files

- `setup.sh` — demo folder
- `dd-verify-image.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
