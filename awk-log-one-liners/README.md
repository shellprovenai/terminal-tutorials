# awk for people who hate awk: 8 one-liners that answer real questions about a log

> 🎬 Video: https://youtu.be/wpnCU4BFD3E (public from Nov 26, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The log and the one idea

```console
$ cat access.log
10.0.0.5 GET /index.html 200 5120 12
10.0.0.7 GET /login 200 2048 30
10.0.0.5 POST /login 302 512 45
10.0.0.9 GET /admin 404 256 3
10.0.0.7 GET /api/orders 500 128 950
10.0.0.5 GET /missing.png 404 256 2
10.0.0.9 GET /api/orders 200 8192 120
10.0.0.7 GET /index.html 200 5120 10
```

## 1. Pick columns

```console
$ awk '{print $1, $4}' access.log
10.0.0.5 200
10.0.0.7 200
10.0.0.5 302
10.0.0.9 404
10.0.0.7 500
10.0.0.5 404
10.0.0.9 200
10.0.0.7 200
```

## 2. Filter lines with a condition

```console
$ awk '$4 >= 400' access.log
10.0.0.9 GET /admin 404 256 3
10.0.0.7 GET /api/orders 500 128 950
10.0.0.5 GET /missing.png 404 256 2
```

```console
$ awk '$4 == 404 {print $3}' access.log
/admin
/missing.png
```

## 3. Sum and average

```console
$ awk '{sum += $5} END {print sum, "bytes"}' access.log
21632 bytes
```

```console
$ awk '{t += $6; n++} END {printf "avg %.1f ms over %d requests\n", t/n, n}' access.log
avg 146.5 ms over 8 requests
```

## 4. Count per value

```console
$ awk '{c[$1]++} END {for (ip in c) print c[ip], ip}' access.log | sort -rn
3 10.0.0.7
3 10.0.0.5
2 10.0.0.9
```

## 5. Other separators and the last field

```console
$ awk -F, 'NR > 1 {print $2 " lives in " $3}' users.csv
Ana lives in Lisbon
Tom lives in Leeds
Mia lives in Graz
```

```console
$ awk '$NF > 100 {print $NF " ms", $3}' access.log
950 ms /api/orders
120 ms /api/orders
```

## The double-quote trap

```console
$ awk "{print $1}" access.log
10.0.0.5 GET /index.html 200 5120 12
10.0.0.7 GET /login 200 2048 30
10.0.0.5 POST /login 302 512 45
10.0.0.9 GET /admin 404 256 3
10.0.0.7 GET /api/orders 500 128 950
10.0.0.5 GET /missing.png 404 256 2
10.0.0.9 GET /api/orders 200 8192 120
10.0.0.7 GET /index.html 200 5120 10
```

## Quick check

**Question 1.** Why does awk "{print $1}" access.log print whole lines?

**Answer:** The shell replaced $1 inside the double quotes — Bash swapped dollar one for its own empty variable before awk ran. Use single quotes around awk programs.

**Question 2.** Which awk variable always holds the last field of a line?

**Answer:** $NF — NF is the number of fields, so $NF is the last one.

Commands that check the answers (run in the same container, after the lesson):

```console
$ echo "{print $1}"
{print }
```

```console
$ awk '{print $1}' access.log | head -2
10.0.0.5
10.0.0.7
```

```console
$ echo "a b c d" | awk '{print NF, $NF}'
4 d
```

## Files

- `setup.sh` — demo folder
- `awk-log-oneliners.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
