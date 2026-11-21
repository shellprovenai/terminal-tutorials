# Undo anything in Git: restore vs reset vs revert (live demos)

> 🎬 Video: premieres Nov 23, 2026 on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `localhost/shellproven-git-undo:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The demo repository

```console
$ git log --oneline
15c907a Enable debug
fd5812a Add currency
1e485e5 Add config
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
fd5812a Add currency
1e485e5 Add config
```

```console
$ git commit -qm "Enable debug (only in dev)" && git log --oneline
c7dd427 Enable debug (only in dev)
fd5812a Add currency
1e485e5 Add config
```

## 4. Drop a commit with reset --hard, then get it back

```console
$ git reset --hard HEAD~1
HEAD is now at fd5812a Add currency
```

```console
$ cat app.conf
price = 10
currency = EUR
```

```console
$ git reflog | head -3
fd5812a HEAD@{0}: reset: moving to HEAD~1
c7dd427 HEAD@{1}: commit: Enable debug (only in dev)
fd5812a HEAD@{2}: reset: moving to HEAD~1
```

```console
$ git reset --hard "HEAD@{1}" && git log --oneline
HEAD is now at c7dd427 Enable debug (only in dev)
c7dd427 Enable debug (only in dev)
fd5812a Add currency
1e485e5 Add config
```

## 5. Undo a shared commit: git revert

```console
$ git revert --no-edit HEAD
[main f9720ea] Revert "Enable debug (only in dev)"
 Date: Sat Nov 21 15:37:12 2026 +0000
 1 file changed, 1 deletion(-)
```

```console
$ git log --oneline && cat app.conf
f9720ea Revert "Enable debug (only in dev)"
c7dd427 Enable debug (only in dev)
fd5812a Add currency
1e485e5 Add config
price = 10
currency = EUR
```

## Files

- `setup.sh` — demo folder
- `git-undo.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
