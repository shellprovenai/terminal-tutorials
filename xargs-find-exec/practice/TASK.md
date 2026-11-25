PRACTICE — lesson 17: xargs and find -exec done right
-----------------------------------------------------
/work/project is a small project full of leftovers. Several file
names have spaces in them, like "old report.bak". Use find with
xargs or -exec:

1. Delete every *.bak file anywhere in /work/project (there are
   four). Nothing else may disappear: notes/draft is a real file
   and must stay. Preview with echo first!
2. Compress every *.log file in /work/project/logs with gzip, one
   file per gzip, up to 4 at a time (xargs -P), so each becomes
   NAME.log.gz. logs/README.txt must stay as it is.

Check: sh /practice/check.sh     Answer: /practice/solution.md
