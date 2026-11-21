# Linux file permissions: read ls -l, fix "Permission denied", and never chmod 777

> 🎬 Video: https://youtu.be/oUAslKIrS1k (public from Nov 23, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Reading ls -l

```console
$ ls -l
total 16
-rw-r--r-- 1 alice web   24 Nov 21 19:15 deploy.sh
-rw-r--r-- 1 alice web    6 Nov 21 19:15 index.html
drwxr-xr-x 2 alice web 4096 Nov 21 19:15 private
-rw-r--r-- 1 alice web   17 Nov 21 19:15 secret.env
```

## From letters to numbers

```console
$ stat -c '%A %a %U:%G %n' *
-rw-r--r-- 644 alice:web deploy.sh
-rw-r--r-- 644 alice:web index.html
drwxr-xr-x 755 alice:web private
-rw-r--r-- 644 alice:web secret.env
```

## Problem 1: the script won't run

```console
$ su alice -c ./deploy.sh
sh: 1: ./deploy.sh: Permission denied
```

```console
$ chmod u+x deploy.sh && su alice -c ./deploy.sh
deployed
```

```console
$ chmod go-w,g+x deploy.sh && stat -c '%A %a %n' deploy.sh
-rwxr-xr-- 754 deploy.sh
```

## Problem 2: a secret anyone can read

```console
$ su bob -c 'cat secret.env'
DB_PASSWORD=demo
```

```console
$ chmod 600 secret.env && su bob -c 'cat secret.env'
cat: secret.env: Permission denied
```

## Problem 3: a private folder

```console
$ chmod 750 private && su bob -c 'ls private'
ls: cannot open directory 'private': Permission denied
```

```console
$ ls -ld private
drwxr-x--- 2 alice web 4096 Nov 21 19:15 private
```

## Why chmod 777 is a bad fix

```console
$ chmod 777 index.html && su bob -c 'echo defaced > index.html' && cat index.html
defaced
```

```console
$ find . -perm -o=w -type f
./index.html
```

```console
$ chmod 644 index.html && su bob -c 'echo again > index.html'
sh: 1: cannot create index.html: Permission denied
```

## Changing the owner with chown

```console
$ chown bob:web index.html && ls -l index.html
-rw-r--r-- 1 bob web 8 Nov 21 19:15 index.html
```

## Quick check

**Question 1.** Alice owns deploy.sh, but running it says Permission denied. Is the fix chmod 777 or chmod u+x?

**Answer:** chmod u+x deploy.sh — Only the execute bit was missing. Seven seven seven would let every user on the system change the script.

**Question 2.** Which mode lets only the owner read and write a password file?

**Answer:** chmod 600 secret.env — Six hundred: read and write for the owner, nothing for the group or anyone else.

Commands that check the answers (run in the same container, after the lesson):

```console
$ stat -c '%A %a %n' deploy.sh
-rwxr-xr-- 754 deploy.sh
```

```console
$ su alice -c ./deploy.sh
deployed
```

```console
$ stat -c '%A %a %n' secret.env
-rw------- 600 secret.env
```

```console
$ su bob -c 'cat secret.env'
cat: secret.env: Permission denied
```

## Files

- `setup.sh` — demo folder
- `linux-permissions.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
