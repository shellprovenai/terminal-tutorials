PRACTICE — lesson 18: sed for the three things you need
-------------------------------------------------------
The server is moving from old.example.com to new.example.com.

1. Edit /work/server.conf in place with sed:
   - delete the comment lines (the ones that START with #),
   - replace EVERY old.example.com with new.example.com.
   Keep the untouched original as /work/server.conf.bak.
   Careful: some settings contain a # inside the line, and one
   line has the old name twice. Try without -i first!
2. Write the lines of /work/cron.log from "=== BEGIN backup" to
   "=== END backup" (both markers included) to /work/backup.txt.
   Don't change cron.log.

Check: sh /practice/check.sh     Answer: /practice/solution.md
