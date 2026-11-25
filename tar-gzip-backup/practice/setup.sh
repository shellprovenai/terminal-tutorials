#!/bin/sh
# setup.sh — builds the practice folder /work/sites/blog (a small blog) and an older backup /work/old-backup.tgz.
# Meant to run inside the throwaway container from start.sh. Only touches /work.
set -e
W=${WORK:-/work}
rm -rf "$W/sites" "$W/blog.tgz" "$W/old-backup.tgz"
mkdir -p "$W/sites/blog/posts" "$W/sites/blog/images" "$W/sites/blog/cache/pages" "$W/sites/blog/drafts"
cd "$W/sites/blog"
printf '# Hello\nFirst post on the new blog.\n' > posts/hello.md
printf '# Tar tips\nKeep the f option last.\n' > posts/tar-tips.md
printf 'About me, version 1\n' > about.md
printf 'Next post: rsync\n' > drafts/rsync.md
printf 'half-written sentence\n' > drafts/rsync.md.tmp
printf 'editor swap\n' > notes.tmp
head -c 4096 /dev/urandom > images/logo.png
head -c 3M /dev/urandom > cache/pages/index.html
# the old backup was made with the full path (tar removed the leading slash)
tar -czf "$W/old-backup.tgz" "$W/sites/blog" 2>/dev/null
# changes made after that backup: a newer about page, and a post broken by a bad edit
printf 'About me, version 2 (newer than the backup)\n' > about.md
printf '<<<<<<< broken by a bad merge\n' > posts/hello.md
echo
cat /practice/TASK.md 2>/dev/null || true
