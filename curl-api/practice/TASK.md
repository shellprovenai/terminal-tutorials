PRACTICE — lesson 20: curl for APIs
-----------------------------------
A small helpdesk API runs in this container on http://localhost:8080
(test server, nothing leaves the container). The API key is in
/work/api-key.txt; the API wants it in the header X-API-Key.

1. Create a ticket with the title "disk full on web1": POST the JSON
   {"title":"disk full on web1"} to http://localhost:8080/tickets.
   Read the key from the file, don't type it into the command.
   You should get status 201. Plain -d is not enough here!
   (GET /tickets with the same header lists the tickets.)
2. /work/backup-check.sh says "backup OK", but there is no backup of
   db1 at all: the server answers 404. Fix the script so that on an
   error answer it does NOT print "backup OK" and exits with a non-zero
   code. For a real backup (try BACKUP_URL=http://localhost:8080/backups/web1
   sh /work/backup-check.sh) it must still print "backup OK".

Check: sh /practice/check.sh     Answer: /practice/solution.md
Start over: sh /practice/setup.sh
