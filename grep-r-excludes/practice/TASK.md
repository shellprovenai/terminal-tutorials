PRACTICE — lesson 02: grep -r without the noise
-----------------------------------------------
/work/shop is a small web shop project. Besides its own code it has
node_modules (two of them, one is frontend/node_modules), .git, a
build folder and a compiled binary in bin. Only the project's own
text files count. Without changing anything inside /work/shop:

1. Write every line that contains "fixme" in ANY case to
   /work/fixme.txt, with file name and line number, like
   ./app/server.js:1:// FIXME: close the db on exit
   Skip node_modules, .git and build. Some notes are lowercase.
2. Write the names of the files that contain the exact text
   api.v2 to /work/files.txt, one per line, sorted, like
   ./config/settings.ini   (same folders skipped, no binaries).
   Careful: api_v2 and api-v2 are NOT the same text.

Check: sh /practice/check.sh     Answer: /practice/solution.md
