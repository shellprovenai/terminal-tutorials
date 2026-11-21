# Bash redirection explained: >, >>, 2>, 2>&1 and | (and why the order matters)

> 🎬 Video: https://youtu.be/2bKrAD4Gl4E (public from Nov 24, 2026)
> 📝 Lesson page with a short quiz: https://shellprovenai.github.io/lekcje/bash-redirection/

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Two output streams

```console
$ ls logs missing
ls: cannot access 'missing': No such file or directory
logs:
a.log
```

## > sends stdout to a file

```console
$ ls logs missing > out.txt
ls: cannot access 'missing': No such file or directory
```

```console
$ cat out.txt
logs:
a.log
```

## 2> sends stderr to a file

```console
$ ls logs missing 2> err.txt
logs:
a.log
```

```console
$ cat err.txt
ls: cannot access 'missing': No such file or directory
```

```console
$ ls logs missing 2>/dev/null
logs:
a.log
```

## 2>&1: both streams into one file

```console
$ ls logs missing > all.txt 2>&1

```

```console
$ cat all.txt
ls: cannot access 'missing': No such file or directory
logs:
a.log
```

```console
$ ls logs missing 2>&1 > wrong.txt
ls: cannot access 'missing': No such file or directory
```

```console
$ cat wrong.txt
logs:
a.log
```

## > overwrites, >> appends

```console
$ echo first > notes.txt && echo second > notes.txt && cat notes.txt
second
```

```console
$ echo third >> notes.txt && cat notes.txt
second
third
```

```console
$ set -o noclobber && echo oops > notes.txt
/tmp/.sp_seg.sh: line 8: notes.txt: cannot overwrite existing file
```

```console
$ set +o noclobber

```

## Pipes only carry stdout

```console
$ ls logs missing | wc -l
ls: cannot access 'missing': No such file or directory
2
```

```console
$ ls logs missing 2>&1 | wc -l
3
```

## tee: save it and see it

```console
$ ls logs missing 2>&1 | tee run.log
ls: cannot access 'missing': No such file or directory
logs:
a.log
```

```console
$ cat run.log
ls: cannot access 'missing': No such file or directory
logs:
a.log
```

## Quick check

**Question 1.** I want stdout and stderr in one file. Is it cmd 2>&1 > all.txt or cmd > all.txt 2>&1?

**Answer:** cmd > all.txt 2>&1 — Redirections run left to right. Point stream one at the file first, then copy stream two there.

**Question 2.** Which arrow adds to the end of a log file instead of wiping it: > or >>?

**Answer:** >> — Two arrows append. A single arrow replaces the whole file.

Commands that check the answers (run in the same container, after the lesson):

```console
$ ls logs missing > quiz.txt 2>&1

```

```console
$ cat quiz.txt
ls: cannot access 'missing': No such file or directory
logs:
a.log
```

```console
$ echo a > quiz2.txt && echo b >> quiz2.txt && cat quiz2.txt
a
b
```

## Files

- `setup.sh` — demo folder
- `bash-redirection.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
