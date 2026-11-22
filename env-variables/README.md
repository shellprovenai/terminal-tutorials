# Environment variables explained: export, .env files, env, and why sudo drops them

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Shell variable or environment variable?

```console
$ GREETING=hello; bash -c 'echo "child sees: [$GREETING]"'
child sees: []
```

```console
$ GREETING=hello; export GREETING; bash -c 'echo "child sees: [$GREETING]"'
child sees: [hello]
```

## Just for one command

```console
$ GREETING=hi bash -c 'echo "child sees: [$GREETING]"'; echo "shell has: [$GREETING]"
child sees: [hi]
shell has: []
```

```console
$ GREETING=hi echo "[$GREETING]"
[]
```

## Inspect the environment with env

```console
$ export GREETING=hello; env | grep -E '^(HOME|SHELL|GREETING)='
HOME=/root
GREETING=hello
```

```console
$ env -i bash -c 'echo "HOME=[$HOME] PATH=[$PATH]"'
HOME=[] PATH=[/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:.]
```

## .env files: the source trap

```console
$ cat app.env
DB_HOST=db.local
DB_PORT=5432
```

```console
$ source app.env; echo "shell: $DB_HOST"; bash -c 'echo "child: [$DB_HOST]"'
shell: db.local
child: []
```

```console
$ set -a; source app.env; set +a; bash -c 'echo "child: [$DB_HOST:$DB_PORT]"'
child: [db.local:5432]
```

## Why sudo drops your variables

```console
$ export DB_HOST=db.local; sudo printenv DB_HOST

```

```console
$ export DB_HOST=db.local; sudo --preserve-env=DB_HOST printenv DB_HOST
db.local
```

## Quick check

**Question 1.** I ran source app.env, but my script still doesn't see DB_HOST. Why?

**Answer:** The variables aren't exported. Use set -a before source — Sourcing sets shell variables only. set -a exports everything assigned while it's on.

**Question 2.** sudo printenv DB_HOST prints nothing. How do I keep just that variable?

**Answer:** sudo --preserve-env=DB_HOST printenv DB_HOST — Sudo resets the environment. --preserve-env with a name lets exactly that variable through.

Commands that check the answers (run in the same container, after the lesson):

```console
$ source app.env; bash -c 'echo "child: [$DB_HOST]"'
child: []
```

```console
$ set -a; source app.env; set +a; bash -c 'echo "child: [$DB_HOST]"'
child: [db.local]
```

```console
$ export DB_HOST=db.local; sudo --preserve-env=DB_HOST printenv DB_HOST
db.local
```

## Files

- `setup.sh` — demo folder
- `env-variables.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
