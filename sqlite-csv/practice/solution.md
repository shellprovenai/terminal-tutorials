# Solution — lesson 05 practice

**Part 1: a typed table.** A plain `.import --csv` would create the table for you, but every column would be TEXT, and
text numbers sort like words (`9.99` above `1500.00`). So create the table with types first. Because the table then
already has column names, `--skip 1` stops the header line from becoming an eleventh row.

**Part 2: GROUP BY and export.** `GROUP BY city` makes one row per city, `COUNT(*)` counts the orders and `SUM(total)`
adds them up. `-header -csv` prints CSV with the column names on top, and `>` saves it to the file.

```sh
cd /work && sqlite3 shop.db "CREATE TABLE orders(id INTEGER, day TEXT, city TEXT, total REAL)" && sqlite3 shop.db ".import --csv --skip 1 orders.csv orders"
cd /work && sqlite3 -header -csv shop.db "SELECT city, COUNT(*) AS orders, ROUND(SUM(total), 2) AS total FROM orders GROUP BY city ORDER BY total DESC" > top.csv
```

Then run `sh /practice/check.sh`: all checks should say PASS.
