# Solution — lesson 17 practice

**Part 1: delete the .bak files.** A plain `find | xargs rm` splits `notes/draft v2.bak` at the space into `notes/draft`
and `v2.bak`, so it would delete the real file `notes/draft` and leave the backup behind. `-print0` with `xargs -0`
keeps every name in one piece, and `rm --` makes sure no name is read as an option. Run it with `echo rm --` first to
see what would be deleted.

**Part 2: compress the logs.** `-n 1` gives each `gzip` one file and `-P 4` runs up to four at the same time. Again
`-print0` and `-0`, because `web 1.log` and `db errors.log` have spaces.

```sh
cd /work/project && find . -name '*.bak' -print0 | xargs -0 rm --
cd /work/project && find logs -name '*.log' -print0 | xargs -0 -n 1 -P 4 gzip
```

Then run `sh /practice/check.sh`: all checks should say PASS.
