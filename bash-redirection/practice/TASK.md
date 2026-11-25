PRACTICE — lesson 06: redirection and pipes
-------------------------------------------
/work/nightly.sh is a (simulated) backup script. It prints progress
on stdout and errors on stderr. /work/logs/nightly.log already holds
the lines of older runs. Don't change nightly.sh.

1. Run ./nightly.sh once so that ALL of its output, the errors
   included, is added to the end of logs/nightly.log. The old lines
   must stay, and nothing should appear on the screen.
2. Count the lines of its output that start with ERROR: using a
   pipe into grep, and save just the number in
   /work/error-count.txt (don't add to nightly.log again).

Check: sh /practice/check.sh     Answer: /practice/solution.md
