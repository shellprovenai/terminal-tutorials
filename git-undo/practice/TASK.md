PRACTICE — lesson 03: undo in Git
---------------------------------
/work/shop is your clone of a small shop website. The repository
/work/origin.git is the shared server, and /work/mate is a teammate
who already pulled everything. Right now in /work/shop you have:
an uncommitted edit in notes.txt (keep it, don't commit it) and a
file secrets.env that you staged with git add by mistake.

1. Unstage secrets.env. Keep the file on disk, and don't commit it.
2. The pushed commit "Raise mug price to 99" was a mistake. Undo it
   so the mug costs 12 again, push the fix to origin, and make sure
   your teammate can still simply pull. Your notes.txt edit must
   survive.

Check: sh /practice/check.sh     Answer: /practice/solution.md
