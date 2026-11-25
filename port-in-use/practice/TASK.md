PRACTICE — lesson 14: free a busy port
--------------------------------------
Your new app must listen on TCP port 5000, but it fails with
"Address already in use". Three servers are running in this
container, on ports 3000, 5000 and 5432. The ones on 3000 and 5432
are needed and must keep running.

1. Find the process that listens on port 5000 and write only its
   PID (just the number) to /work/pid.txt.
2. Stop that process so port 5000 is free. It saves its data when
   it gets the polite SIGTERM, so it must not be killed harder
   than that.

Check: sh /practice/check.sh     Answer: /practice/solution.md
