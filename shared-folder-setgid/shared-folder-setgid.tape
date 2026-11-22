# A shared folder two users can both edit: groups, setgid and umask (without chmod 777)
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs shared-folder-setgid.tape
Output shared-folder-setgid.mp4
Set Shell "bash"
Set FontFamily "Noto Sans Mono"
Set FontSize 38
Set LineHeight 1.25
Set Width 1920
Set Height 1080
Set Framerate 30
Set Padding 48
Set TypingSpeed 40ms
Set Theme "GitHub Dark"
Set WindowBar Colorful
Set CursorBlink false

Hide
Type `mkdir -p /srv && cd /srv && clear`
Enter
Type `groupadd web && useradd -m -s /bin/bash -G web alice && useradd -m -s /bin/bash -G web bob && mkdir -p /srv/site`
Enter
Type `clear`
Enter
Show

# --- The problem
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The problem`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chown alice /srv/site && su alice -c 'echo "<h1>Home</h1>" > /srv/site/index.html' && ls -l /srv/site`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `su bob -c 'echo "<p>news</p>" >> /srv/site/index.html'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 5477ms

# --- Step 1: a shared group on the folder
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 1: a shared group on the folder`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chgrp web /srv/site && chmod 775 /srv/site && ls -ld /srv/site`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1622ms
Sleep 300ms
Type `su alice -c 'touch /srv/site/about.html' && ls -l /srv/site/about.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms

# --- Step 2: setgid, new files inherit the group
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 2: setgid, new files inherit the group`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chmod 2775 /srv/site && ls -ld /srv/site`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 9636ms
Sleep 300ms
Type `su alice -c 'touch /srv/site/contact.html' && ls -l /srv/site/contact.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1861ms

# --- Step 3: umask, so the group can write
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Step 3: umask, so the group can write`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `su alice -c umask; umask`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 13299ms
Sleep 300ms
Type `su alice -c 'umask 022 && touch /srv/site/blog.html' && ls -l /srv/site/blog.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 6786ms
Sleep 300ms
Type `su bob -c 'echo "<p>first post</p>" >> /srv/site/blog.html'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1600ms
Sleep 300ms
Type `su alice -c 'umask 002 && touch /srv/site/news.html' && su bob -c 'echo "<p>first post</p>" >> /srv/site/news.html' && ls -l /srv/site/news.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 11501ms

# --- Fix the files that already exist
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Fix the files that already exist`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `chgrp -R web /srv/site && find /srv/site -type d -exec chmod 2775 {} + && find /srv/site -type f -exec chmod 664 {} + && ls -l /srv/site`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4943ms
Sleep 13991ms

# --- The trap: mv keeps the old group
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# The trap: mv keeps the old group`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `su alice -c 'umask 002 && echo "draft" > ~/faq.html && mv ~/faq.html /srv/site/' && ls -l /srv/site/faq.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 300ms
Type `su bob -c 'echo "edit" >> /srv/site/faq.html'`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 8284ms
Sleep 300ms
Type `chgrp web /srv/site/faq.html && su bob -c 'echo "edit" >> /srv/site/faq.html' && ls -l /srv/site/faq.html`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1779ms
