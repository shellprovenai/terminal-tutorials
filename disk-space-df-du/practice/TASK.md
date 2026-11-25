PRACTICE — lesson 07: find what's eating the disk
-------------------------------------------------
/work/var is a small server: logs, a cache, mail and a website.
A program is running and still writes to log/app/app.log.

1. Write the size of each folder directly inside /work/var to
   /work/usage.txt, one line each, human-readable (like 25M),
   sorted from the smallest to the biggest. Do this first.
   Careful: the sizes have one, two or three digits.
2. Free the space used by /work/var/log/app/app.log. The program
   must keep running and the file must still be there (empty).
   Don't delete or change any other file.

Check: sh /practice/check.sh     Answer: /practice/solution.md
