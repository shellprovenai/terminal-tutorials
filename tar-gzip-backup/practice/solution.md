# Solution — lesson 11 practice

**Part 1: a small archive with short paths.** `-C /work/sites` changes into the parent folder first, so naming just
`blog` gives paths like `blog/posts/hello.md`. The `--exclude` options go before the folder name, and the quotes keep
the shell away from `'*.tmp'`.

**Part 2: one file from an archive made with a full path.** `tar -tzf /work/old-backup.tgz` shows that the old backup
stores `work/sites/blog/...` (tar removed only the leading slash). Extract just that one member into an empty folder,
then copy it back. Extracting the whole archive over the blog would also bring back the old `about.md`.

```sh
tar -czf /work/blog.tgz --exclude=cache --exclude='*.tmp' -C /work/sites blog
mkdir -p /tmp/old && tar -xzf /work/old-backup.tgz -C /tmp/old work/sites/blog/posts/hello.md && cp /tmp/old/work/sites/blog/posts/hello.md /work/sites/blog/posts/hello.md
```

Then run `sh /practice/check.sh`: all checks should say PASS.
