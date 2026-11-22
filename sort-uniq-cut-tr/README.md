# sort, uniq -c, cut and tr: the text toolbox for logs and CSV files (and their traps)

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## cut: pick a column

```console
$ cat access.log
10.0.0.5 GET /index.html 200
10.0.0.7 GET /login 200
10.0.0.5 POST /login 302
10.0.0.9 GET /admin 404
10.0.0.7 GET /api 500
10.0.0.5 GET /missing 404
10.0.0.9 GET /login 200
10.0.0.5 GET /index.html 200
```

```console
$ cut -d ' ' -f1 access.log | head -4
10.0.0.5
10.0.0.7
10.0.0.5
10.0.0.9
```

```console
$ cut -d, -f2 orders.csv
city
Leeds
lisbon
Graz
Leeds
Lisbon
graz
```

## Count values: sort | uniq -c

```console
$ cut -d ' ' -f1 access.log | uniq -c
      1 10.0.0.5
      1 10.0.0.7
      1 10.0.0.5
      1 10.0.0.9
      1 10.0.0.7
      1 10.0.0.5
      1 10.0.0.9
      1 10.0.0.5
```

```console
$ cut -d ' ' -f1 access.log | sort | uniq -c
      4 10.0.0.5
      2 10.0.0.7
      2 10.0.0.9
```

```console
$ cut -d ' ' -f1 access.log | sort | uniq -c | sort -rn
      4 10.0.0.5
      2 10.0.0.9
      2 10.0.0.7
```

```console
$ cut -d ' ' -f4 access.log | sort | uniq -c | sort -rn
      4 200
      2 404
      1 500
      1 302
```

## tr: clean up before counting

```console
$ tail -n +2 orders.csv | cut -d, -f2 | sort | uniq -c
      1 Graz
      2 Leeds
      1 Lisbon
      1 graz
      1 lisbon
```

```console
$ tail -n +2 orders.csv | cut -d, -f2 | tr 'A-Z' 'a-z' | sort | uniq -c | sort -rn
      2 lisbon
      2 leeds
      2 graz
```

## The trap: repeated spaces

```console
$ printf 'alice    12  Leeds\nbob      7   Graz\n' > aligned.txt && cut -d ' ' -f2 aligned.txt

```

```console
$ tr -s ' ' < aligned.txt | cut -d ' ' -f2
12
7
```

## Sort numbers correctly

```console
$ tail -n +2 orders.csv | sort -t, -k3
1,Leeds,12
3,Graz,120
5,Lisbon,15
4,Leeds,30
6,graz,8
2,lisbon,9
```

```console
$ tail -n +2 orders.csv | sort -t, -k3 -n
6,graz,8
2,lisbon,9
1,Leeds,12
5,Lisbon,15
4,Leeds,30
3,Graz,120
```

## Quick check

**Question 1.** uniq -c shows the same IP several times with small counts. What's missing?

**Answer:** sort before uniq -c — uniq only merges neighbouring lines. Sorting puts equal lines together.

**Question 2.** cut -d ' ' -f2 returns empty lines on aligned columns. What fixes it?

**Answer:** Squeeze the spaces first: tr -s ' ' | cut -d ' ' -f2 — Repeated spaces create empty fields. tr -s turns them into single spaces.

Commands that check the answers (run in the same container, after the lesson):

```console
$ cut -d ' ' -f1 access.log | uniq -c | wc -l
8
```

```console
$ cut -d ' ' -f1 access.log | sort | uniq -c | wc -l
3
```

```console
$ tr -s ' ' < aligned.txt | cut -d ' ' -f2
12
7
```

## Files

- `setup.sh` — demo folder
- `sort-uniq-cut-tr.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
