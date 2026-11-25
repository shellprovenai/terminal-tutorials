#!/bin/sh
# check.sh — checks the lesson 11 practice. Run it inside the practice container: sh /practice/check.sh
W=${WORK:-/work}
B="$W/sites/blog"
fails=0
pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; fails=$((fails + 1)); }

# Rule: the blog keeps its 8 files, the newer about.md and nothing extracted on top of it
nested=$(find "$W/work" "$W/sites/work" "$B/work" -maxdepth 0 2>/dev/null | head -1)
if [ -n "$nested" ]; then
  fail "the old backup was extracted to $nested/sites/blog/... — it stores the full path; extract only hello.md into an empty folder (and delete $nested)"
elif [ "$(find "$B" -type f 2>/dev/null | wc -l)" -ne 8 ] || [ ! -f "$B/cache/pages/index.html" ]; then
  fail "files in /work/sites/blog were removed or added — run sh /practice/setup.sh to start over"
elif ! grep -q "version 2" "$B/about.md"; then
  fail "about.md was overwritten with the old version — don't extract the whole backup over the blog, take only hello.md"
else pass "the blog still has its 8 files and the newer about.md"
fi

# Part 1: blog.tgz with short paths, without cache and *.tmp
want="blog/about.md
blog/drafts/rsync.md
blog/images/logo.png
blog/posts/hello.md
blog/posts/tar-tips.md"
if [ ! -f "$W/blog.tgz" ]; then
  fail "/work/blog.tgz does not exist yet"
elif ! gzip -t "$W/blog.tgz" 2>/dev/null; then
  fail "/work/blog.tgz is not a gzip file — did you use -z (tar -czf)?"
else
  got=$(tar -tzf "$W/blog.tgz" | sed 's|^\./||' | grep -v '/$' | sort)
  if [ "$got" = "$want" ]; then pass "blog.tgz has the 5 blog files with paths starting with blog/"
  elif echo "$got" | grep -q '^work/'; then fail "blog.tgz stores work/sites/blog/... — use -C /work/sites and name just blog"
  elif echo "$got" | grep -q 'cache/'; then fail "blog.tgz still contains the cache folder — add --exclude=cache before the folder name"
  elif echo "$got" | grep -q '\.tmp$'; then fail "blog.tgz still contains *.tmp files — add --exclude='*.tmp' (with the quotes)"
  else
    fail "blog.tgz has the wrong files"
    echo "      expected: $(echo "$want" | tr '\n' ' ')"
    echo "      found:    $(echo "$got" | tr '\n' ' ')"
  fi
fi

# Part 2: hello.md is back to the version from the old backup
if [ "$(cat "$B/posts/hello.md" 2>/dev/null)" = "$(printf '# Hello\nFirst post on the new blog.')" ]; then
  pass "posts/hello.md is restored from the old backup"
else
  fail "posts/hello.md is not restored yet — tar -tzf /work/old-backup.tgz shows the exact path to extract"
fi

echo
if [ $fails -eq 0 ]; then echo "RESULT: PASS — well done"; else echo "RESULT: FAIL ($fails check(s) failed)"; fi
[ $fails -eq 0 ]
