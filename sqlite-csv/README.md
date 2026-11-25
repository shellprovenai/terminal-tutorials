# SQLite in the terminal: query a CSV file in 5 minutes (and the text-number trap)

> 🎬 Video: https://youtu.be/HDbG6iW3WRM (public from Nov 22, 2026)
> 📝 Lesson page with a short quiz: https://shellprovenai.github.io/lekcje/sqlite-csv/

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The CSV file

```console
$ cat sales.csv
date,region,product,amount
2026-01-14,north,keyboard,49.90
2026-01-20,south,monitor,189.00
2026-02-03,north,mouse,9.50
2026-02-11,west,monitor,179.00
2026-02-27,south,keyboard,52.00
2026-03-05,west,mouse,12.00
2026-03-09,north,monitor,199.00
2026-03-18,south,mouse,8.75
2026-03-30,west,keyboard,47.50
```

## Import with one command

```console
$ sqlite3 shop.db ".import --csv sales.csv sales"

```

```console
$ sqlite3 shop.db ".schema sales"
CREATE TABLE IF NOT EXISTS "sales"(
"date" TEXT, "region" TEXT, "product" TEXT, "amount" TEXT);
```

## The trap: numbers stored as text

```console
$ sqlite3 shop.db "SELECT product, amount FROM sales ORDER BY amount DESC LIMIT 3"
mouse|9.50
mouse|8.75
keyboard|52.00
```

```console
$ sqlite3 shop.db "SELECT product, amount FROM sales ORDER BY CAST(amount AS REAL) DESC LIMIT 3"
monitor|199.00
monitor|189.00
monitor|179.00
```

## The real fix: a typed table

```console
$ rm shop.db && sqlite3 shop.db "CREATE TABLE sales(date TEXT, region TEXT, product TEXT, amount REAL)"

```

```console
$ sqlite3 shop.db ".import --csv --skip 1 sales.csv sales"

```

```console
$ sqlite3 shop.db "SELECT typeof(amount), COUNT(*) FROM sales GROUP BY 1"
real|9
```

## Answering questions with GROUP BY

```console
$ sqlite3 -header -column shop.db "SELECT region, COUNT(*) AS orders, ROUND(SUM(amount), 2) AS total FROM sales GROUP BY region ORDER BY total DESC"
region  orders  total 
------  ------  ------
north   3       258.4 
south   3       249.75
west    3       238.5 
```

## Dates and months

```console
$ sqlite3 -header -column shop.db "SELECT date, product, amount FROM sales WHERE date >= '2026-03-01' ORDER BY date"
date        product   amount
----------  --------  ------
2026-03-05  mouse     12.0  
2026-03-09  monitor   199.0 
2026-03-18  mouse     8.75  
2026-03-30  keyboard  47.5  
```

```console
$ sqlite3 -header -column shop.db "SELECT substr(date, 1, 7) AS month, ROUND(SUM(amount), 2) AS total FROM sales GROUP BY month"
month    total 
-------  ------
2026-01  238.9 
2026-02  240.5 
2026-03  267.25
```

## Export the result back to CSV

```console
$ sqlite3 -header -csv shop.db "SELECT product, ROUND(AVG(amount), 2) AS avg_price FROM sales GROUP BY product" > report.csv

```

```console
$ cat report.csv
product,avg_price
keyboard,49.8
monitor,189.0
mouse,10.08
```

## Quick check

**Question 1.** After a plain .import, ORDER BY amount puts a 9.50 mouse above a 189 monitor. Why?

**Answer:** amount was imported as TEXT — Text is sorted like words, character by character. Create a typed table, or cast the column to a number.

**Question 2.** My table already has column names. Which option stops .import from loading the header as a row?

**Answer:** .import --csv --skip 1 — --skip 1 drops the first line, so you get nine sales and no header row.

Commands that check the answers (run in the same container, after the lesson):

```console
$ sqlite3 /tmp/quiz.db ".import --csv sales.csv s" && sqlite3 /tmp/quiz.db "SELECT DISTINCT typeof(amount) FROM s"
text
```

```console
$ sqlite3 shop.db "SELECT COUNT(*) FROM sales"
9
```

## Practice

Try it yourself, without the video: `practice/start.sh` opens a throwaway container (podman or docker) with the task, `sh /practice/check.sh` tells you when you're done, `practice/solution.md` has the answer. Tested: `practice-test.log` (FAIL before, PASS after the solution).

## Files

- `setup.sh` — demo folder
- `sqlite-csv.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
