# Solution — lesson 04 practice

**Part 1: find and fix the 777 files.** `find -perm -o=w` lists files where *at least* the write bit for others is set.
Without the dash (`-perm o=w`) find looks for that exact mode and finds nothing. Save the list first, then set
755 for the script (everyone may run it, only dave may change it) and 644 for the normal files.

**Part 2: secrets and the private folder.** `600` gives read and write to the owner and nothing to anyone else. A folder
needs `x` to be entered: with `740` erin could list the names but not open `notes.txt`. `750` gives dave everything,
the group read and enter, and others nothing.

```sh
cd /work/app && find . -type f -perm -o=w | sort > /work/writable.txt && chmod 755 run.sh && chmod 644 index.php img/logo.png
cd /work/app && chmod 600 db.env && chmod 750 private
```

Then run `sh /practice/check.sh`: all checks should say PASS.
