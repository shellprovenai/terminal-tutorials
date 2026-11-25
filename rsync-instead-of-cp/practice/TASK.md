PRACTICE — lesson 12: rsync instead of cp
-----------------------------------------
/work/docs holds a team's documents. /work/mirror is a copy of it
from last week: since then a file changed, one was added and two
were deleted. Editor swap files (*.swp) and the .cache folder must
never go into the mirror. Don't change anything inside /work/docs.

1. First a preview: save the rsync dry run (one line per change,
   deletions included) to /work/preview.txt. The mirror must not
   change yet. It should list the two deleted files.
2. Now make /work/mirror match /work/docs for real: same files,
   same modification times, the deleted files removed, no *.swp,
   no .cache. Careful with the slash: the files belong directly in
   /work/mirror, not in /work/mirror/docs.

Check: sh /practice/check.sh     Answer: /practice/solution.md
