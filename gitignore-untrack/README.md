# .gitignore not working? Untrack files that are already committed (git rm --cached)

> 🎬 Video: https://youtu.be/eFFnLC99j7o (public from Dec 2, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The problem

```console
$ git ls-files
.env
app.py
build/app.bin
logs/app.log
```

```console
$ printf '.env\n*.log\nbuild/\n' > .gitignore && echo "more" >> logs/app.log && git status --short
 M logs/app.log
?? .gitignore
```

## Why: .gitignore only applies to untracked files

```console
$ git check-ignore -v --no-index logs/app.log .env build/app.bin
.gitignore:2:*.log	logs/app.log
.gitignore:1:.env	.env
.gitignore:3:build/	build/app.bin
```

## The fix: git rm --cached

```console
$ git rm -q --cached .env logs/app.log && git rm -q -r --cached build && git status --short
D  .env
D  build/app.bin
D  logs/app.log
?? .gitignore
```

```console
$ ls -A && ls logs build
.env
.git
.gitignore
app.py
build
logs
build:
app.bin

logs:
app.log
```

```console
$ git add .gitignore && git commit -qm "Stop tracking .env, logs and build" && echo "again" >> logs/app.log && git status --short && echo "clean"
clean
```

## Surprise 1: the secret is still in history

```console
$ git show HEAD~1:.env
API_KEY=demo-secret-123
```

## Surprise 2: teammates lose their local copy

```console
$ cd /lab/teammate && ls -A && git pull -q && ls -A
.env
.git
app.py
build
logs
.git
.gitignore
app.py
```

## Quick check

**Question 1.** I added .env to .gitignore, but git status still shows changes to it. Why?

**Answer:** It is already tracked. Run git rm --cached .env and commit — Ignore rules only apply to untracked files. Untrack it first, then the rule works.

**Question 2.** Does git rm --cached delete the file from my disk?

**Answer:** No, it only removes it from Git's index — The file stays on disk. Plain git rm, without --cached, would delete it.

Commands that check the answers (run in the same container, after the lesson):

```console
$ git check-ignore -v --no-index .env
.gitignore:1:.env	.env
```

```console
$ git ls-files .env | wc -l
0
```

```console
$ ls .env && git ls-files .env | wc -l
.env
0
```

## Files

- `setup.sh` — demo folder
- `gitignore-untrack.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
