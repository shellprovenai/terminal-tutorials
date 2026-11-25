PRACTICE — lesson 05: from CSV to answers with SQLite
-----------------------------------------------------
/work/orders.csv holds ten orders of a small online shop. The first
line is the header: id,day,city,total. Don't change orders.csv.

1. Create /work/shop.db with a table orders and load all ten orders
   into it. id must be stored as an integer and total as a real
   number (check with typeof), and the header must not become a row.
2. Write /work/top.csv: one line per city with the number of orders
   and the sum of total rounded to 2 decimals, biggest sum first,
   with the header line city,orders,total.

Check: sh /practice/check.sh     Answer: /practice/solution.md
