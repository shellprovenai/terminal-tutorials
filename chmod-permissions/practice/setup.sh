#!/bin/sh
# setup.sh — builds the practice folder /work/app (a small web app that someone "fixed" with chmod 777)
# and three users: dave (owner), erin (in the group devs) and mallory (not in the group).
# Meant to run inside the throwaway container from start.sh. Only touches /work (and the container's user list).
set -e
W=${WORK:-/work}
getent group devs >/dev/null || groupadd devs
for u in dave erin mallory; do id "$u" >/dev/null 2>&1 || useradd -m "$u"; done
usermod -aG devs dave && usermod -aG devs erin
rm -rf "$W/app" "$W/writable.txt"
mkdir -p "$W/app/img" "$W/app/private"
cd "$W/app"
printf '#!/bin/sh\necho "app started"\n' > run.sh
printf '<?php echo "Hello"; ?>\n' > index.php
printf 'body { color: #333; }\n' > style.css
echo "PNG" > img/logo.png
echo "DB_PASSWORD=s3cret" > db.env
echo "salary review on Friday" > private/notes.txt
chown -R dave:devs "$W/app"
chmod 755 "$W/app" "$W/app/img" "$W/app/private"
chmod 644 style.css db.env private/notes.txt
chmod 777 run.sh index.php img/logo.png
echo
cat /practice/TASK.md 2>/dev/null || true
