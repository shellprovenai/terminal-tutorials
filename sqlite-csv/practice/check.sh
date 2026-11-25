#!/bin/sh
# check.sh — checks the lesson 05 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }
q() { sqlite3 "$W/shop.db" "$1" 2>/dev/null; }

# Rule: orders.csv unchanged
if [ "$(cksum < "$W/orders.csv" 2>/dev/null)" = "1029240763 314" ]; then pass "orders.csv is unchanged"
else fail "orders.csv was changed — run sh /practice/setup.sh to start over"
fi

# Part 1: shop.db with a typed table orders, 10 rows, no header row
if [ ! -f "$W/shop.db" ]; then
  fail "/work/shop.db does not exist yet"
elif ! q "SELECT 1 FROM orders LIMIT 1" | grep -q 1; then
  fail "shop.db has no table orders with rows in it"
else
  n=$(q "SELECT COUNT(*) FROM orders")
  hdr=$(q "SELECT COUNT(*) FROM orders WHERE city = 'city' OR total = 'total'")
  ttot=$(q "SELECT group_concat(DISTINCT typeof(total)) FROM orders WHERE city <> 'city'")
  tid=$(q "SELECT group_concat(DISTINCT typeof(id)) FROM orders WHERE city <> 'city'")
  if [ "$hdr" != 0 ]; then
    fail "the header line was loaded as a row — your table already has column names, so import with --skip 1"
  elif [ "$n" != 10 ]; then
    fail "orders has $n rows, it should have 10"
  elif [ "$ttot" != real ] || [ "$tid" != integer ]; then
    fail "total is stored as $ttot and id as $tid — a plain .import makes every column TEXT; create the table with types (id INTEGER, total REAL) first, then import"
  elif [ "$(q "SELECT id FROM orders ORDER BY total DESC LIMIT 1")" != 1010 ]; then
    fail "the rows don't look right — ORDER BY total DESC should start with order 1010"
  else pass "orders has 10 rows, id is integer, total is real, no header row"
  fi
fi

# Part 2: top.csv
want="city,orders,total
Krakow,4,2775.4
Gdansk,3,1367.5
Poznan,3,504.19"
if [ ! -f "$W/top.csv" ]; then
  fail "/work/top.csv does not exist yet"
else
  got=$(tr -d '\r' < "$W/top.csv" | grep -v '^$' | awk -F, 'NR == 1 { print; next } { printf "%s,%d,%.10g\n", $1, $2, $3 }')
  if [ "$got" = "$want" ]; then pass "top.csv has the right totals per city, biggest first, with the header"
  elif [ "$(echo "$got" | head -1)" != "city,orders,total" ]; then
    fail "the first line of top.csv should be city,orders,total — sqlite3 prints it with -header (and name the columns with AS)"
  elif [ "$(echo "$got" | sed 1d | sort -t, -k3,3gr)" = "$(echo "$want" | sed 1d)" ]; then
    fail "top.csv has the right numbers but in the wrong order — biggest sum first (ORDER BY ... DESC)"
  else
    fail "top.csv has the wrong lines"
    echo "      expected: $(echo "$want" | tr '\n' ' ')"
    echo "      found:    $(echo "$got" | tr '\n' ' ')"
  fi
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
