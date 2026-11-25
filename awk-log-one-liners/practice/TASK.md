PRACTICE — lesson 10: answer questions about a log with awk
-----------------------------------------------------------
/work/app.log is a web shop's request log. Each line is:
  time  user  status  message (any number of words)  ms
The last word is always the request's duration in milliseconds.
Don't change /work/app.log.

1. Write every request slower than 1000 ms to
   /work/report/slow.txt as "user ms", one per line, in log
   order, like: tom 2300
2. Write the total time per user to /work/report/users.txt as
   "user total", one per line, biggest total first.
   Careful: the messages don't all have the same number of words.

Check: sh /practice/check.sh     Answer: /practice/solution.md
