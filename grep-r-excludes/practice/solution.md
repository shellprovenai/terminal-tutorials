# Solution — lesson 02 practice

**Part 1: every fixme line, any case, without the noise.** `-r` searches the whole folder, `-n` adds line numbers, `-i`
also catches the lowercase `# fixme` in `app/cart.py`, and `-I` skips the binary. `--exclude-dir` takes a folder name, so
`--exclude-dir=node_modules` skips `frontend/node_modules` too. The options are written out one by one, so the line also
works in plain `sh` (the `{a,b,c}` shortcut is a bash feature).

**Part 2: the exact text api.v2.** In a pattern a dot matches any character, so plain `grep "api.v2"` also lists
`app/legacy.py` (`api_v2`) and `docs/notes.md` (`api-v2`). `-F` treats the pattern as plain text, `-l` prints just the
file names, and `-I` keeps the binary `bin/shopd` out of the list.

```sh
cd /work/shop && grep -rniI "fixme" --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=build . > /work/fixme.txt
cd /work/shop && grep -rlIF "api.v2" --exclude-dir=node_modules --exclude-dir=.git --exclude-dir=build . | sort > /work/files.txt
```

Then run `sh /practice/check.sh`: all checks should say PASS.
