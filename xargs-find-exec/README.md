# xargs and find -exec done right: spaces in file names, -print0, and parallel jobs

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The space problem

```console
$ ls
My Report.txt
Q3 plan.txt
logs
notes.txt
old 2.tmp
old1.tmp
```

```console
$ find . -name '*.txt' | xargs wc -l
3 ./notes.txt
wc: ./My: No such file or directory
wc: Report.txt: No such file or directory
wc: ./Q3: No such file or directory
wc: plan.txt: No such file or directory
3 total
```

## The fix: -print0 and xargs -0

```console
$ find . -name '*.txt' -print0 | xargs -0 wc -l
 3 ./notes.txt
 2 ./My Report.txt
 1 ./Q3 plan.txt
 6 total
```

## find -exec: \; or +

```console
$ find . -name '*.txt' -exec echo run {} \;
run ./notes.txt
run ./My Report.txt
run ./Q3 plan.txt
```

```console
$ find . -name '*.txt' -exec echo run {} +
run ./notes.txt ./My Report.txt ./Q3 plan.txt
```

## Preview before you delete

```console
$ find . -name '*.tmp' -print0 | xargs -0 echo rm --
rm -- ./old 2.tmp ./old1.tmp
```

```console
$ find . -name '*.tmp' -print0 | xargs -0 rm -- && ls
My Report.txt
Q3 plan.txt
logs
notes.txt
```

## Parallel jobs with xargs -P

```console
$ time (printf '1\n1\n1\n1\n' | xargs -n 1 sleep)

real	0m4.006s
user	0m0.005s
sys	0m0.001s
```

```console
$ time (printf '1\n1\n1\n1\n' | xargs -n 1 -P 4 sleep)

real	0m1.003s
user	0m0.005s
sys	0m0.000s
```

```console
$ find logs -name '*.log' -print0 | xargs -0 -n 1 -P 4 gzip && ls logs
app 1.log.gz
app 2.log.gz
app 3.log.gz
app 4.log.gz
```

## Quick check

**Question 1.** find . -name '*.txt' | xargs wc -l breaks on "My Report.txt". What fixes it?

**Answer:** find . -name '*.txt' -print0 | xargs -0 wc -l — Null bytes can't appear in file names, so -print0 with -0 splits the list safely.

**Question 2.** find -exec cmd {} \; versus find -exec cmd {} + — what is the difference?

**Answer:** \; runs the command once per file, + passes many files at once — The plus form works like xargs and is much faster for many files.

Commands that check the answers (run in the same container, after the lesson):

```console
$ find . -name '*.txt' -print0 | xargs -0 wc -l
 3 ./notes.txt
 2 ./My Report.txt
 1 ./Q3 plan.txt
 6 total
```

```console
$ find . -name '*.txt' -exec echo run {} \;
run ./notes.txt
run ./My Report.txt
run ./Q3 plan.txt
```

```console
$ find . -name '*.txt' -exec echo run {} +
run ./notes.txt ./My Report.txt ./Q3 plan.txt
```

## Files

- `setup.sh` — demo folder
- `xargs-find-exec.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
