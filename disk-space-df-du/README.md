# Disk full? Find what's eating your space with df, du and sort (Linux)

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Step 1: which filesystem is full? df -h

```console
$ df -h /lab
Filesystem      Size  Used Avail Use% Mounted on
overlay          59G   21G   36G  37% /
```

## Step 2: which folder? du -sh

```console
$ du -sh *
93M	app
205M	backups
3.1M	uploads
```

## Step 3: drill down with --max-depth and sort -h

```console
$ du -h --max-depth=2 . | sort -h
3.1M	./uploads
25M	./app/cache
69M	./app/logs
93M	./app
205M	./backups
300M	.
```

```console
$ du -ah . | sort -rh | head -6
300M	.
205M	./backups
104M	./backups/db-2026-11.sql.gz
100M	./backups/db-2026-10.sql.gz
93M	./app
69M	./app/logs
```

## Step 4: list the big files with find

```console
$ find . -type f -size +50M -exec ls -lh {} +
-rw-r--r-- 1 root root  60M Nov 21 19:39 ./app/logs/app.log.1
-rw-r--r-- 1 root root 100M Nov 21 19:39 ./backups/db-2026-10.sql.gz
-rw-r--r-- 1 root root 104M Nov 21 19:39 ./backups/db-2026-11.sql.gz
```

## Step 5: free space safely

```console
$ truncate -s 0 app/logs/app.log.1 && du -sh app
33M	app
```

## The mystery: df says full, du disagrees

```console
$ fallocate -l 200M big.tmp && du -sh .
440M	.
```

```console
$ sleep 600 < big.tmp &

```

```console
$ rm big.tmp && du -sh .
240M	.
```

```console
$ find /proc/*/fd -lname '*(deleted)' -printf '%p -> %l\n' 2>/dev/null
/proc/120/fd/0 -> /lab/srv/big.tmp (deleted)
```

```console
$ kill %1

```

## Quick check

**Question 1.** After du -h, why sort -h and not plain sort?

**Answer:** sort -h understands sizes like 9M and 100M — Plain sort compares text, so a hundred megabytes would land before nine megabytes.

**Question 2.** I deleted a 200 MB file, but df still counts the space as used. What is the likely cause?

**Answer:** A process still has the deleted file open — The space comes back only when that process closes the file, or is restarted.

Commands that check the answers (run in the same container, after the lesson):

```console
$ printf '100M\n9M\n1G\n' | sort
100M
1G
9M
```

```console
$ printf '100M\n9M\n1G\n' | sort -h
9M
100M
1G
```

```console
$ fallocate -l 10M quiz.tmp && { sleep 30 < quiz.tmp & p=$!; rm quiz.tmp; ls -l /proc/$p/fd/0 | sed 's/.*-> //'; kill $p; }
/lab/srv/quiz.tmp (deleted)
```

## Files

- `setup.sh` — demo folder
- `disk-usage.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
