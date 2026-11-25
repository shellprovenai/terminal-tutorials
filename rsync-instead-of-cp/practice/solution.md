# Solution — lesson 12 practice

**Part 1: preview first.** `-a` is archive mode, `-i` prints one line per change, `-n` makes it a dry run, and
`--delete` adds the files that no longer exist in `docs`. The two `--exclude` patterns keep the swap file and the cache
out. The slash after `docs/` means "the contents of docs", so the paths in the list start at the top of the mirror.

**Part 2: the same command without `-n`.** Once the preview shows exactly the two deletions, the new `budget.csv` and
the changed `notes.md`, run it for real. Without the slash after `docs`, rsync would create `/work/mirror/docs`
instead, and the old files at the top of the mirror would stay.

```sh
cd /work && rsync -ain --delete --exclude='*.swp' --exclude=.cache/ docs/ mirror/ > /work/preview.txt
cd /work && rsync -ai --delete --exclude='*.swp' --exclude=.cache/ docs/ mirror/
```

Then run `sh /practice/check.sh`: all checks should say PASS.
