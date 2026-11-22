# rsync instead of cp: copy only what changed, dry-run first, and the trailing-slash trap

> 🎬 Video: https://youtu.be/3YrSm6wADKw (public from Nov 23, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The first copy: rsync -a

```console
$ find photos -type f | sort
photos/2026/a.jpg
photos/2026/b.jpg
photos/2026/c.jpg
photos/cache/thumbs.tmp
photos/notes.txt
photos/old.txt
```

```console
$ rsync -a photos/ backup/

```

```console
$ find backup -type f | sort
backup/2026/a.jpg
backup/2026/b.jpg
backup/2026/c.jpg
backup/cache/thumbs.tmp
backup/notes.txt
backup/old.txt
```

## Only what changed: -i

```console
$ echo "Day 2: rain" >> photos/notes.txt && rsync -ai photos/ backup/
>f.st...... notes.txt
```

```console
$ rsync -ai photos/ backup/ && echo "nothing to copy"
nothing to copy
```

## Deletions: dry run first

```console
$ rm photos/old.txt && rsync -ai photos/ backup/ && ls backup
.d..t...... ./
2026
cache
notes.txt
old.txt
```

```console
$ rsync -ain --delete photos/ backup/
*deleting   old.txt
```

```console
$ ls backup
2026
cache
notes.txt
old.txt
```

```console
$ rsync -ai --delete photos/ backup/ && ls backup
*deleting   old.txt
2026
cache
notes.txt
```

## The trailing-slash trap

```console
$ rsync -a photos/ copy1/ && ls copy1
2026
cache
notes.txt
```

```console
$ rsync -a photos copy2/ && ls copy2
photos
```

## Skip files with --exclude

```console
$ rsync -ai --delete --exclude='*.tmp' --exclude=cache/ photos/ clean/
created directory clean
cd+++++++++ ./
>f+++++++++ notes.txt
cd+++++++++ 2026/
>f+++++++++ 2026/a.jpg
>f+++++++++ 2026/b.jpg
>f+++++++++ 2026/c.jpg
```

```console
$ find clean -type f | sort
clean/2026/a.jpg
clean/2026/b.jpg
clean/2026/c.jpg
clean/notes.txt
```

## Quick check

**Question 1.** Which command copies only the contents of photos into backup: rsync -a photos backup/ or rsync -a photos/ backup/?

**Answer:** rsync -a photos/ backup/ — The slash after the source means its contents. Without it, you get backup slash photos.

**Question 2.** Before running rsync with --delete for the first time, what should you add?

**Answer:** -n (a dry run) — -n shows every deletion and changes nothing. Run for real only when the list looks right.

Commands that check the answers (run in the same container, after the lesson):

```console
$ ls copy1
2026
cache
notes.txt
```

```console
$ ls copy2
photos
```

```console
$ rsync -ain --delete photos/ copy2/ && ls copy2
*deleting   photos/cache/thumbs.tmp
*deleting   photos/cache/
*deleting   photos/2026/c.jpg
*deleting   photos/2026/b.jpg
*deleting   photos/2026/a.jpg
*deleting   photos/2026/
*deleting   photos/notes.txt
*deleting   photos/
.d..t...... ./
>f+++++++++ notes.txt
cd+++++++++ 2026/
>f+++++++++ 2026/a.jpg
>f+++++++++ 2026/b.jpg
>f+++++++++ 2026/c.jpg
cd+++++++++ cache/
>f+++++++++ cache/thumbs.tmp
photos
```

## Files

- `setup.sh` — demo folder
- `rsync-instead-of-cp.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
