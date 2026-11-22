# A shared folder two users can both edit: groups, setgid and umask (without chmod 777)

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The problem

```console
$ chown alice /srv/site && su alice -c 'echo "<h1>Home</h1>" > /srv/site/index.html' && ls -l /srv/site
total 4
-rw-rw-r-- 1 alice alice 14 Nov 22 00:51 index.html
```

```console
$ su bob -c 'echo "<p>news</p>" >> /srv/site/index.html'
bash: line 1: /srv/site/index.html: Permission denied
```

## Step 1: a shared group on the folder

```console
$ chgrp web /srv/site && chmod 775 /srv/site && ls -ld /srv/site
drwxrwxr-x 2 alice web 4096 Nov 22 00:51 /srv/site
```

```console
$ su alice -c 'touch /srv/site/about.html' && ls -l /srv/site/about.html
-rw-rw-r-- 1 alice alice 0 Nov 22 00:51 /srv/site/about.html
```

## Step 2: setgid, new files inherit the group

```console
$ chmod 2775 /srv/site && ls -ld /srv/site
drwxrwsr-x 2 alice web 4096 Nov 22 00:51 /srv/site
```

```console
$ su alice -c 'touch /srv/site/contact.html' && ls -l /srv/site/contact.html
-rw-rw-r-- 1 alice web 0 Nov 22 00:51 /srv/site/contact.html
```

## Step 3: umask, so the group can write

```console
$ su alice -c umask; umask
0002
0022
```

```console
$ su alice -c 'umask 022 && touch /srv/site/blog.html' && ls -l /srv/site/blog.html
-rw-r--r-- 1 alice web 0 Nov 22 00:51 /srv/site/blog.html
```

```console
$ su bob -c 'echo "<p>first post</p>" >> /srv/site/blog.html'
bash: line 1: /srv/site/blog.html: Permission denied
```

```console
$ su alice -c 'umask 002 && touch /srv/site/news.html' && su bob -c 'echo "<p>first post</p>" >> /srv/site/news.html' && ls -l /srv/site/news.html
-rw-rw-r-- 1 alice web 18 Nov 22 00:51 /srv/site/news.html
```

## Fix the files that already exist

```console
$ chgrp -R web /srv/site && find /srv/site -type d -exec chmod 2775 {} + && find /srv/site -type f -exec chmod 664 {} + && ls -l /srv/site
total 8
-rw-rw-r-- 1 alice web  0 Nov 22 00:51 about.html
-rw-rw-r-- 1 alice web  0 Nov 22 00:51 blog.html
-rw-rw-r-- 1 alice web  0 Nov 22 00:51 contact.html
-rw-rw-r-- 1 alice web 14 Nov 22 00:51 index.html
-rw-rw-r-- 1 alice web 18 Nov 22 00:51 news.html
```

## The trap: mv keeps the old group

```console
$ su alice -c 'umask 002 && echo "draft" > ~/faq.html && mv ~/faq.html /srv/site/' && ls -l /srv/site/faq.html
-rw-rw-r-- 1 alice alice 6 Nov 22 00:51 /srv/site/faq.html
```

```console
$ su bob -c 'echo "edit" >> /srv/site/faq.html'
bash: line 1: /srv/site/faq.html: Permission denied
```

```console
$ chgrp web /srv/site/faq.html && su bob -c 'echo "edit" >> /srv/site/faq.html' && ls -l /srv/site/faq.html
-rw-rw-r-- 1 alice web 11 Nov 22 00:51 /srv/site/faq.html
```

## Quick check

**Question 1.** New files in /srv/site keep getting their creator's personal group. What fixes that?

**Answer:** chmod g+s /srv/site (the setgid bit) — With setgid on a folder, new files inherit the folder's group.

**Question 2.** Alice moved a file into the shared folder with mv, and Bob can't edit it. Why?

**Answer:** mv keeps the file's old group. setgid only applies to new files — Copy the file instead, or run chgrp with the shared group after moving it.

Commands that check the answers (run in the same container, after the lesson):

```console
$ su bob -c 'umask 002 && touch /srv/site/quiz.html' && stat -c '%G %A %n' /srv/site/quiz.html
web -rw-rw-r-- /srv/site/quiz.html
```

```console
$ su alice -c 'echo x > ~/q.html && mv ~/q.html /srv/site/' && stat -c '%G %n' /srv/site/q.html
alice /srv/site/q.html
```

## Files

- `setup.sh` — demo folder
- `shared-folder-setgid.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
