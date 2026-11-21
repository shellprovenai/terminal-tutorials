# Find files changed in the last 24 hours (and the -mtime +1 trap)

> 🎬 Video: premieres Nov 22, 2026 on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The demo folder

```console
$ find . -type f -printf '%TY-%Tm-%Td %TH:%TM  %p\n' | sort
2026-11-16 15:35  ./LICENSE
2026-11-19 13:35  ./src/old_notes.txt
2026-11-19 16:35  ./README.md
2026-11-20 09:35  ./src/utils.py
2026-11-20 19:35  ./src/config.yaml
2026-11-21 12:35  ./logs/app.log
2026-11-21 14:35  ./node_modules/pkg/index.js
2026-11-21 15:25  ./src/app.py
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
2026-11-20 19:35  ./src/config.yaml
2026-11-21 12:35  ./logs/app.log
2026-11-21 15:25  ./src/app.py
```

## Back up today's changes safely

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440 -print0 | tar --null -T - -czf /tmp/recent.tgz

```

```console
$ tar -tzvf /tmp/recent.tgz
-rw-r--r-- root/root         5 2026-11-21 15:25 ./src/app.py
-rw-r--r-- root/root         5 2026-11-20 19:35 ./src/config.yaml
-rw-r--r-- root/root         5 2026-11-21 12:35 ./logs/app.log
```

```console
$ find . -path ./node_modules -prune -o -type f -mmin -1440 -exec ls -l {} +
-rw-r--r-- 1 root root 5 Nov 21 12:35 ./logs/app.log
-rw-r--r-- 1 root root 5 Nov 21 15:25 ./src/app.py
-rw-r--r-- 1 root root 5 Nov 20 19:35 ./src/config.yaml
```

## Files

- `setup.sh` — demo folder
- `find-changed-24h.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
