# Search a whole project with grep -r, without node_modules, .git or binary junk

> 🎬 Video: premieres Nov 22, 2026 on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The noisy first search

```console
$ grep -r "TODO" .
./src/client.js:// TODO: handle errors
./src/auth.py:    # TODO: rate limit
./.git/config:	# TODO nothing
./node_modules/left-pad/index.js:// TODO upstream bug
./dist/app.min.js:function a(){/*TODO*/return 1}
grep: ./bin/tool: binary file matches
```

## Skip folders with --exclude-dir

```console
$ grep -rn "TODO" --exclude-dir=node_modules --exclude-dir=.git .
./src/client.js:1:// TODO: handle errors
./src/auth.py:2:    # TODO: rate limit
./dist/app.min.js:1:function a(){/*TODO*/return 1}
grep: ./bin/tool: binary file matches
```

## Ignore binary files with -I

```console
$ grep -rnI "TODO" --exclude-dir={node_modules,.git,dist} .
./src/client.js:1:// TODO: handle errors
./src/auth.py:2:    # TODO: rate limit
```

## Case, file types and file names

```console
$ grep -rniI "todo" --exclude-dir={node_modules,.git,dist} .
./src/main.py:2:# todo: remove debug flag
./src/client.js:1:// TODO: handle errors
./src/auth.py:2:    # TODO: rate limit
```

```console
$ grep -rl "TODO" --include="*.py" .
./src/auth.py
```

## Whole words with -w

```console
$ grep -rn "log" logs src
logs/app.log:1:2026 login ok
logs/app.log:2:2026 user log out
src/client.js:2:fetch("/api/catalog")
src/auth.py:1:def login(user):
```

```console
$ grep -rnw "log" logs src
logs/app.log:2:2026 user log out
```

## Dots are wildcards: use -F

```console
$ grep -rn "1.5" src logs
src/main.py:4:VERSION = "1.5"
logs/app.log:3:version 105 started
```

```console
$ grep -rnF "1.5" src logs
src/main.py:4:VERSION = "1.5"
```

## Several patterns and some context

```console
$ grep -rnIE "TODO|FIXME|DEBUG" --exclude-dir={node_modules,.git,dist} .
./src/main.py:3:DEBUG = True
./src/client.js:1:// TODO: handle errors
./src/auth.py:2:    # TODO: rate limit
```

```console
$ grep -n -A 1 "TODO" src/auth.py
2:    # TODO: rate limit
3-    return check(user)
```

## Files

- `setup.sh` — demo folder
- `grep-r-exclude.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
