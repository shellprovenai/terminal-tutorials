# Undo anything in Git: restore vs reset vs revert (live demos)

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The demo repository

```console
$ git log --oneline
f1f7a48 Enable debug
b01e5d3 Add currency
52e0461 Add config
```

## 1. Throw away an edit: git restore

```console
$ echo "price = 0" >> app.conf

```

```console
$ git status --short
 M app.conf
```

```console
$ git restore app.conf

```

```console
$ cat app.conf
price = 10
currency = EUR
debug = true
```

## 2. Unstage a file: git restore --staged

```console
$ echo "tax = 23" >> app.conf && git add app.conf && git status --short
M  app.conf
```

```console
$ git restore --staged app.conf && git status --short
 M app.conf
```

```console
$ git restore app.conf

```

## 3. Undo the last commit, keep the changes: reset --soft

```console
$ git reset --soft HEAD~1

```

```console
$ git status --short && git log --oneline
M  app.conf
b01e5d3 Add currency
52e0461 Add config
```

```console
$ git commit -qm "Enable debug (only in dev)" && git log --oneline
4949205 Enable debug (only in dev)
b01e5d3 Add currency
52e0461 Add config
```

## 4. Drop a commit with reset --hard, then get it back

```console
$ git reset --hard HEAD~1
HEAD is now at b01e5d3 Add currency
```

```console
$ cat app.conf
price = 10
currency = EUR
```

```console
$ git reflog | head -3
b01e5d3 HEAD@{0}: reset: moving to HEAD~1
4949205 HEAD@{1}: commit: Enable debug (only in dev)
b01e5d3 HEAD@{2}: reset: moving to HEAD~1
```

```console
$ git reset --hard "HEAD@{1}" && git log --oneline
HEAD is now at 4949205 Enable debug (only in dev)
4949205 Enable debug (only in dev)
b01e5d3 Add currency
52e0461 Add config
```

## 5. Undo a shared commit: git revert

```console
$ git revert --no-edit HEAD
[main e8bee19] Revert "Enable debug (only in dev)"
 Date: Sat Nov 21 19:07:10 2026 +0000
 1 file changed, 1 deletion(-)
```

```console
$ git log --oneline && cat app.conf
e8bee19 Revert "Enable debug (only in dev)"
4949205 Enable debug (only in dev)
b01e5d3 Add currency
52e0461 Add config
price = 10
currency = EUR
```

## Quick check

**Question 1.** My bad commit is already pushed, and my team pulled it. Do I use reset or revert?

**Answer:** git revert HEAD — Revert adds a new commit that undoes the change, so nobody's history breaks. Reset rewrites history.

**Question 2.** I ran git reset --hard and the commit vanished. Is it gone for good?

**Answer:** No. git reflog, then git reset --hard HEAD@{1} — Not right away. git reflog still lists it, and you can reset back to it.

Commands that check the answers (run in the same container, after the lesson):

```console
$ git log --oneline
e8bee19 Revert "Enable debug (only in dev)"
4949205 Enable debug (only in dev)
b01e5d3 Add currency
52e0461 Add config
```

```console
$ git reflog | head -5
e8bee19 HEAD@{0}: revert: Revert "Enable debug (only in dev)"
4949205 HEAD@{1}: reset: moving to HEAD@{1}
b01e5d3 HEAD@{2}: reset: moving to HEAD~1
4949205 HEAD@{3}: commit: Enable debug (only in dev)
b01e5d3 HEAD@{4}: reset: moving to HEAD~1
```

## Files

- `setup.sh` — demo folder
- `git-undo.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
