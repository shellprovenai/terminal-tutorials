# sed for the three things you actually need: replace in place, delete lines, print a range

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Replace: s/old/new/

```console
$ cat app.conf
# app settings
host=localhost
port=8080
admin_port=8080

# links
url=http://localhost:8080/health?port=8080#start
debug=true
```

```console
$ sed 's/8080/9090/' app.conf
# app settings
host=localhost
port=9090
admin_port=9090

# links
url=http://localhost:9090/health?port=8080#start
debug=true
```

```console
$ sed 's/8080/9090/g' app.conf | grep 9090
port=9090
admin_port=9090
url=http://localhost:9090/health?port=9090#start
```

```console
$ grep 8080 app.conf
port=8080
admin_port=8080
url=http://localhost:8080/health?port=8080#start
```

## Edit in place, with a backup

```console
$ sed -i.bak 's/^port=8080/port=9090/' app.conf

```

```console
$ diff app.conf.bak app.conf
3c3
< port=8080
---
> port=9090
```

## The trap: -i without a backup

```console
$ sed -i '/#/d' app.conf && cat app.conf
host=localhost
port=9090
admin_port=8080

debug=true
```

```console
$ cp app.conf.bak app.conf && sed -i 's/^port=8080/port=9090/' app.conf

```

```console
$ sed '/^#/d' app.conf
host=localhost
port=9090
admin_port=8080

url=http://localhost:8080/health?port=8080#start
debug=true
```

## Delete lines

```console
$ sed '/^#/d; /^$/d' app.conf
host=localhost
port=9090
admin_port=8080
url=http://localhost:8080/health?port=8080#start
debug=true
```

```console
$ sed '2d; $d' app.conf
# app settings
port=9090
admin_port=8080

# links
url=http://localhost:8080/health?port=8080#start
```

## Print a range

```console
$ sed -n '10,15p' app.log
2026-11-20 10:00:10 INFO request 10
2026-11-20 10:00:11 INFO request 11
2026-11-20 10:00:12 ERROR request 12
2026-11-20 10:00:13 INFO request 13
2026-11-20 10:00:14 INFO request 14
--- START deploy
```

```console
$ sed -n '/ERROR/p' app.log
2026-11-20 10:00:12 ERROR request 12
2026-11-20 10:00:21 ERROR request 21
```

```console
$ sed -n '/START/,/END/p' app.log
--- START deploy
2026-11-20 10:00:15 INFO request 15
2026-11-20 10:00:16 INFO request 16
--- END deploy
```

```console
$ echo "root=/var/www/html" | sed 's|/var/www|/srv/www|'
root=/srv/www/html
```

## Quick check

**Question 1.** How do I edit a file in place with sed and keep a copy of the original?

**Answer:** sed -i.bak 's/old/new/' file — -i.bak saves the original first. Plain -i changes the file with no way back.

**Question 2.** Which command prints only lines 10 to 15 of app.log?

**Answer:** sed -n '10,15p' app.log — Without -n, sed prints every line, and the range twice.

Commands that check the answers (run in the same container, after the lesson):

```console
$ ls app.conf*
app.conf
app.conf.bak
```

```console
$ diff app.conf.bak app.conf
3c3
< port=8080
---
> port=9090
```

```console
$ sed -n '10,15p' app.log | wc -l
6
```

```console
$ sed '10,15p' app.log | wc -l
38
```

## Files

- `setup.sh` — demo folder
- `sed-essentials.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
