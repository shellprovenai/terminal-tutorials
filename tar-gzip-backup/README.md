# tar and gzip without the usual mistakes: back up a folder, skip the junk, verify the archive

> 🎬 Video: https://youtu.be/qmOhkBLBX7k (public from Nov 23, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The project folder

```console
$ find project -type f | sort
project/README.md
project/logs/app.log
project/node_modules/lib/bundle.bin
project/src/app.py
project/src/config.ini
```

```console
$ du -sh project
8.1M	project
```

## Create an archive and look inside

```console
$ tar -czf backup.tgz project

```

```console
$ ls -lh backup.tgz
-rw-r--r-- 1 root root 8.1M Nov 21 20:16 backup.tgz
```

```console
$ tar -tzf backup.tgz
project/
project/src/
project/src/app.py
project/src/config.ini
project/node_modules/
project/node_modules/lib/
project/node_modules/lib/bundle.bin
project/logs/
project/logs/app.log
project/README.md
```

## The trap: absolute paths

```console
$ tar -czf abs.tgz /lab/work/project
tar: Removing leading `/' from member names
```

```console
$ tar -tzf abs.tgz | head -3
lab/work/project/
lab/work/project/src/
lab/work/project/src/app.py
```

```console
$ mkdir /tmp/restore && tar -xzf abs.tgz -C /tmp/restore && find /tmp/restore -maxdepth 3 -type d
/tmp/restore
/tmp/restore/lab
/tmp/restore/lab/work
/tmp/restore/lab/work/project
```

```console
$ tar -czf good.tgz -C /lab/work project && tar -tzf good.tgz | head -3
project/
project/src/
project/src/app.py
```

## Skip the junk with --exclude

```console
$ tar -czf small.tgz --exclude=node_modules --exclude='*.log' -C /lab/work project

```

```console
$ tar -tzf small.tgz
project/
project/src/
project/src/app.py
project/src/config.ini
project/logs/
project/README.md
```

```console
$ ls -lh good.tgz small.tgz
-rw-r--r-- 1 root root 8.1M Nov 21 20:16 good.tgz
-rw-r--r-- 1 root root  282 Nov 21 20:16 small.tgz
```

## Verify the backup

```console
$ gzip -t small.tgz && echo "gzip OK"
gzip OK
```

```console
$ tar -dzf small.tgz -C /lab/work && echo "archive matches the disk"
archive matches the disk
```

```console
$ echo "debug = true" > project/src/config.ini && tar -dzf small.tgz -C /lab/work
project/src/config.ini: Mod time differs
project/src/config.ini: Size differs
```

```console
$ printf 'debug = false\n' > project/src/config.ini && tar -czf small.tgz --exclude=node_modules --exclude='*.log' -C /lab/work project

```

## Restore one file

```console
$ mkdir /tmp/one && tar -xzf small.tgz -C /tmp/one project/src/config.ini && find /tmp/one -type f
/tmp/one/project/src/config.ini
```

## Quick check

**Question 1.** I archived /lab/work/project by its full path and extracted it in /tmp/restore. Where are my files?

**Answer:** /tmp/restore/lab/work/project — Tar keeps the whole path, minus the leading slash. Use -C with the parent folder to get short paths.

**Question 2.** How can I prove an archive still matches the files on disk?

**Answer:** tar -dzf small.tgz -C /lab/work — gzip -t only checks the compression. tar -d compares every file, and prints nothing when they match.

Commands that check the answers (run in the same container, after the lesson):

```console
$ tar -tzf abs.tgz | head -2
lab/work/project/
lab/work/project/src/
```

```console
$ gzip -t small.tgz && echo "gzip OK"
gzip OK
```

```console
$ tar -dzf small.tgz -C /lab/work && echo "archive matches the disk"
archive matches the disk
```

## Files

- `setup.sh` — demo folder
- `tar-gzip-backup.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
