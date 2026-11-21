# Find files changed in the last 24 hours (and the -mtime +1 trap)

> 🎬 Video: https://youtu.be/lIVTi5okxE4 (public from Nov 22, 2026)
> 📝 Lesson page with a short quiz: https://shellprovenai.github.io/lekcje/find-changed-24h/

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The demo folder

```console
$ find . -type f -printf '%TY-%Tm-%Td %TH:%TM  %p\n' | sort
2026-11-16 18:19  ./LICENSE
2026-11-19 16:19  ./src/old_notes.txt
2026-11-19 19:19  ./README.md
2026-11-20 12:19  ./src/utils.py
2026-11-20 22:19  ./src/config.yaml
2026-11-21 15:19  ./logs/app.log
2026-11-21 17:19  ./node_modules/pkg/index.js
2026-11-21 18:09  ./src/app.py
```

## Modified in the last 24 hours: -mtime -1

```console
$ find . -type f -mtime -1
./src/app.py
./src/config.yaml
./node_modules/pkg/index.js
./logs/app.log
```

## The trap: -mtime 1 and -mtime +1

```console
$ find . -type f -mtime 1
./src/utils.py
./README.md
```

```console
$ find . -type f -mtime +1
./src/old_notes.txt
./LICENSE
```

## Exact times with -mmin

```console
$ find . -type f -mmin -120
./src/app.py
./node_modules/pkg/index.js
```

## Human-readable dates with -newermt

```console
$ find . -type f -newermt '6 hours ago'
./src/app.py
./node_modules/pkg/index.js
./logs/app.log
```

```console
$ find . -type f -newermt '2000-01-01' | wc -l
8
```

```console
$ find . -type f -newermt '2 days ago' ! -newermt '1 day ago'
./src/utils.py
./README.md
```

## Skipping folders with -prune

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440
./src/app.py
./src/config.yaml
./node_modules
./logs/app.log
```

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440 -print
./src/app.py
./src/config.yaml
./logs/app.log
```

## Show when each file changed

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440 -printf '%TY-%Tm-%Td %TH:%TM  %p\n' | sort
2026-11-20 22:19  ./src/config.yaml
2026-11-21 15:19  ./logs/app.log
2026-11-21 18:09  ./src/app.py
```

## Back up today's changes safely

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440 -print0 | tar --null -T - -czf /tmp/recent.tgz

```

```console
$ tar -tzvf /tmp/recent.tgz
-rw-r--r-- root/root         5 2026-11-21 18:09 ./src/app.py
-rw-r--r-- root/root         5 2026-11-20 22:19 ./src/config.yaml
-rw-r--r-- root/root         5 2026-11-21 15:19 ./logs/app.log
```

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440 -exec ls -l {} +
-rw-r--r-- 1 root root 5 Nov 21 15:19 ./logs/app.log
-rw-r--r-- 1 root root 5 Nov 21 18:09 ./src/app.py
-rw-r--r-- 1 root root 5 Nov 20 22:19 ./src/config.yaml
```

## Quick check

**Question 1.** I want every file changed in the last 24 hours. Do I use -mtime 1 or -mtime -1?

**Answer:** find . -type f -mtime -1 — -mtime -1 means less than one day old. Plain one means one to two days old.

**Question 2.** README.md is 47 hours old. Will find . -type f -mtime +1 list it?

**Answer:** No. Use -mmin +1440 instead — No. Forty-seven hours rounds down to one day, and one is not greater than one.

Commands that check the answers (run in the same container, after the lesson):

```console
$ find . -type f -mtime -1
./src/app.py
./src/config.yaml
./node_modules/pkg/index.js
./logs/app.log
```

```console
$ find . -type f -mtime 1
./src/utils.py
./README.md
```

```console
$ find . -type f -mtime +1
./src/old_notes.txt
./LICENSE
```

```console
$ find . -type f -mmin +1440
./src/utils.py
./src/old_notes.txt
./LICENSE
./README.md
```

## Files

- `setup.sh` — demo folder
- `find-changed-24h.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
