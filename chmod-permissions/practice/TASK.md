PRACTICE — lesson 04: fix permissions without 777
-------------------------------------------------
/work/app belongs to dave and the group devs. erin is in devs,
mallory is not. Someone "fixed" a Permission denied with chmod 777
on a few files. Don't change any owner, and don't delete files:

1. Write the regular files in /work/app that everyone (others) can
   write to /work/writable.txt, one per line, sorted, like
   ./index.php. Then fix them: run.sh gets 755, the others 644.
2. Lock up the secrets: only dave may read and write db.env, and
   the folder private must let dave do everything, let the devs
   group list it and open notes.txt, and keep mallory out.

Check: sh /practice/check.sh     Answer: /practice/solution.md
