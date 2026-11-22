# Bash scripts that don't destroy things: set -euo pipefail, quoting, [[ ]] and ${VAR:?}

> 🎬 Video: https://youtu.be/kxhpskLJ91g (public from Dec 12, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## set -e: stop at the first error

```console
$ cat clean.sh
#!/bin/bash
cd /lab/scripts/biuld
echo "cleaning in: $(pwd)"
```

```console
$ bash clean.sh
clean.sh: line 2: cd: /lab/scripts/biuld: No such file or directory
cleaning in: /lab/scripts
```

```console
$ bash clean-safe.sh
clean-safe.sh: line 3: cd: /lab/scripts/biuld: No such file or directory
```

## set -u and ${VAR:?}: no silent empty variables

```console
$ unset BUILD_DIR; echo rm -rf "$BUILD_DIR/"
rm -rf /
```

```console
$ bash -c 'set -u; echo rm -rf "$BUILD_DIR/"'
bash: line 1: BUILD_DIR: unbound variable
```

```console
$ bash -c 'BUILD_DIR=""; echo rm -rf "${BUILD_DIR:?is empty}/"'
bash: line 1: BUILD_DIR: is empty
```

## pipefail: failures inside a pipeline

```console
$ grep ERROR missing.log | wc -l; echo "exit code: $?"
grep: missing.log: No such file or directory
0
exit code: 0
```

```console
$ set -o pipefail; grep ERROR missing.log | wc -l; echo "exit code: $?"
grep: missing.log: No such file or directory
0
exit code: 2
```

## Quote your variables

```console
$ file="my notes.txt"; ls -l $file
ls: cannot access 'my': No such file or directory
ls: cannot access 'notes.txt': No such file or directory
```

```console
$ file="my notes.txt"; ls -l "$file"
-rw-r--r-- 1 root root 0 Nov 22 01:49 my notes.txt
```

```console
$ for f in *.txt; do echo "found: $f"; done
found: draft.txt
found: my notes.txt
```

## [[ ]] instead of [ ]

```console
$ answer=""; [ $answer = yes ] && echo "yes"
/tmp/.sp_seg.sh: line 2: [: =: unary operator expected
```

```console
$ answer=""; [[ $answer == yes ]] || echo "not yes"; name="report.csv"; [[ $name == *.csv ]] && echo "a CSV file"
not yes
a CSV file
```

## Let shellcheck find it for you

```console
$ printf '#!/bin/bash\ncd $1\nrm -rf $DIR/*\nfor f in $(ls); do echo $f; done\n' > bad.sh && cat bad.sh
#!/bin/bash
cd $1
rm -rf $DIR/*
for f in $(ls); do echo $f; done
```

```console
$ shellcheck -f gcc bad.sh
bad.sh:2:1: warning: Use 'cd ... || exit' or 'cd ... || return' in case cd fails. [SC2164]
bad.sh:2:4: note: Double quote to prevent globbing and word splitting. [SC2086]
bad.sh:3:8: warning: Use "${var:?}" to ensure this never expands to /* . [SC2115]
bad.sh:3:8: note: Double quote to prevent globbing and word splitting. [SC2086]
bad.sh:4:10: error: Iterating over ls output is fragile. Use globs. [SC2045]
bad.sh:4:25: note: Double quote to prevent globbing and word splitting. [SC2086]
```

## Quick check

**Question 1.** A script's cd fails and the script keeps running in the wrong folder. What prevents that?

**Answer:** set -e (better: set -euo pipefail) at the top — With set -e, the first failing command ends the script.

**Question 2.** file="my notes.txt"; rm $file — what happens?

**Answer:** rm tries to delete "my" and "notes.txt". Quote it: rm "$file" — An unquoted variable is split on spaces. Quotes keep the name in one piece.

Commands that check the answers (run in the same container, after the lesson):

```console
$ bash clean-safe.sh
clean-safe.sh: line 3: cd: /lab/scripts/biuld: No such file or directory
```

```console
$ file="my notes.txt"; ls $file
ls: cannot access 'my': No such file or directory
ls: cannot access 'notes.txt': No such file or directory
```

## Files

- `setup.sh` — demo folder
- `bash-safe-scripts.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
