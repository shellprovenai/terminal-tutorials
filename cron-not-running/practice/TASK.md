PRACTICE — lesson 09: a cron job that really works
--------------------------------------------------
/work/jobs/dump.sh makes a nightly database dump. It calls the
tool dumptool from /work/bin and writes dump.sql into the folder
it runs in. By hand it works:
  cd /work/jobs && PATH=/work/bin:$PATH ./dump.sh
Don't change dump.sh or dumptool. Write a crontab file
/work/dump.cron and install it with crontab:

1. Run dump.sh every day at 02:30 so that it works in cron's
   environment (PATH is only /usr/bin:/bin, the job starts in
   /root), dump.sql lands in /work/jobs, and BOTH the output and
   the errors are appended to /work/logs/dump.log.
2. Then change the log to one file per day, named with today's
   date, like /work/logs/dump-2026-11-25.log ($(date +%F)).
   Install the new version too.

Check: sh /practice/check.sh     Answer: /practice/solution.md
(check.sh runs your job the way cron would: same PATH, same
folder, same handling of special characters.)
