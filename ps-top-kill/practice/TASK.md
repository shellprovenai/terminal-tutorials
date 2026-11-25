PRACTICE — lesson 13: ps, top and kill
--------------------------------------
Three programs from /work/bin are running in the background.
One of them is eating a whole CPU core.

1. Find the process that uses the most CPU and write its name
   (just the name, like sshd) to /work/culprit.txt. Then stop it.
   thumbnail-cache is a different program: it must keep running.
2. Stop the exporter so that it can finish properly: when it gets
   the right signal it writes END to /work/export.csv and removes
   /work/exporter.lock. A stale lock file means you did it wrong.

Check: sh /practice/check.sh     Answer: /practice/solution.md
Start over: sh /practice/setup.sh
