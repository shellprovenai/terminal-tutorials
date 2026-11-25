PRACTICE — lesson 11: tar and gzip without the usual mistakes
-------------------------------------------------------------
/work/sites/blog is a small blog. cache/ is 3 MB of generated
pages, and the *.tmp files are editor leftovers.
/work/old-backup.tgz is an older backup of the blog.

1. Create /work/blog.tgz (tar + gzip) with the blog, but without
   the cache folder and without any *.tmp file. Paths inside the
   archive must start with blog/ (not work/sites/blog/).
2. posts/hello.md was broken by a bad edit. Restore ONLY that file
   from /work/old-backup.tgz. Everything else in the blog must
   stay as it is: about.md is newer than the backup, keep it.
   List the old archive first: how are its paths stored?

Check: sh /practice/check.sh     Answer: /practice/solution.md
