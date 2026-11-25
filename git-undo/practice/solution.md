# Solution — lesson 03 practice

**Part 1: unstage secrets.env.** `git restore --staged` takes the file out of the staging area and leaves it on disk.
Do this first: `git revert` refuses to run while something is staged.

**Part 2: undo a pushed commit.** The commit is already on the server and your teammate has it, so don't rewrite history
with `git reset --hard` (plus a force push). That would also wipe your uncommitted notes.txt edit, and git has no copy of
it. `git revert` adds a new commit that does the opposite, touches only `prices.csv`, and everyone can simply pull it.

```sh
cd /work/shop && git restore --staged secrets.env
cd /work/shop && git revert --no-edit HEAD && git push origin main
```

Then run `sh /practice/check.sh`: all checks should say PASS.
