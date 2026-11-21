# SQLite in the terminal: query a CSV file in 5 minutes (and the text-number trap)
# ShellProven — nagrywane VHS; polecenia sprawdzone w localhost/shellproven-sqlite-csv:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs sqlite-csv.tape
Output sqlite-csv.mp4
Set Shell "bash"
Set FontFamily "Noto Sans Mono"
Set FontSize 38
Set LineHeight 1.25
Set Width 1920
Set Height 1080
Set Framerate 30
Set Padding 48
Set TypingSpeed 40ms
Set Theme "GitHub Dark"
Set WindowBar Colorful
Set CursorBlink false

Hide
Type `mkdir -p /lab/data && cd /lab/data && clear`
Enter
Type `printf 'date,region,product,amount\n2026-01-14,north,keyboard,49.90\n2026-01-20,south,monitor,189.00\n2026-02-03,north,mouse,9.50\n2026-02-11,west,monitor,179.00\n2026-02-27,south,keyboard,52.00\n2026-03-05,west,mouse,12.00\n2026-03-09,north,monitor,199.00\n2026-03-18,south,mouse,8.75\n2026-03-30,west,keyboard,47.50\n' > sales.csv`
Enter
Type `clear`
Enter
Show

# --- The CSV file
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The CSV file`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `cat sales.csv`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6839ms
Sleep 6872ms

# --- Import with one command
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Import with one command`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sqlite3 shop.db ".import --csv sales.csv sales"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8978ms
Sleep 300ms
Type `sqlite3 shop.db ".schema sales"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8097ms
Sleep 6817ms

# --- The trap: numbers stored as text
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: numbers stored as text`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sqlite3 shop.db "SELECT product, amount FROM sales ORDER BY amount DESC LIMIT 3"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 13004ms
Sleep 300ms
Type `sqlite3 shop.db "SELECT product, amount FROM sales ORDER BY CAST(amount AS REAL) DESC LIMIT 3"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 6375ms

# --- The real fix: a typed table
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The real fix: a typed table`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `rm shop.db && sqlite3 shop.db "CREATE TABLE sales(date TEXT, region TEXT, product TEXT, amount REAL)"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8866ms
Sleep 300ms
Type `sqlite3 shop.db ".import --csv --skip 1 sales.csv sales"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `sqlite3 shop.db "SELECT typeof(amount), COUNT(*) FROM sales GROUP BY 1"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3005ms

# --- Answering questions with GROUP BY
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Answering questions with GROUP BY`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sqlite3 -header -column shop.db "SELECT region, COUNT(*) AS orders, ROUND(SUM(amount), 2) AS total FROM sales GROUP BY region ORDER BY total DESC"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 8594ms

# --- Dates and months
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Dates and months`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sqlite3 -header -column shop.db "SELECT date, product, amount FROM sales WHERE date >= '2026-03-01' ORDER BY date"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3034ms
Sleep 300ms
Type `sqlite3 -header -column shop.db "SELECT substr(date, 1, 7) AS month, ROUND(SUM(amount), 2) AS total FROM sales GROUP BY month"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 8338ms

# --- Export the result back to CSV
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Export the result back to CSV`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `sqlite3 -header -csv shop.db "SELECT product, ROUND(AVG(amount), 2) AS avg_price FROM sales GROUP BY product" > report.csv`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3696ms
Sleep 300ms
Type `cat report.csv`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 3501ms
