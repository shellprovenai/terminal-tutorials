PRACTICE — lesson 01: find files by age
---------------------------------------
/work/site is a small website project. Its files were changed at
different times, from 10 minutes to 6 days ago. Without changing
anything inside /work/site:

1. Create /work/changed.tgz with every regular file in /work/site
   changed in the last 24 hours, but nothing from site/cache.
   One file name has a space in it, and it must be in the archive.
2. Write the files NOT changed for more than 72 hours (3 days) to
   /work/old.txt, one per line, sorted, like ./LICENSE.
   Exactly 72 hours, so be careful with how find rounds days.

Check: sh /practice/check.sh     Answer: /practice/solution.md
