PRACTICE — lesson 15: why did the service fail?
-----------------------------------------------
/work/journal is the systemd journal copied from server web1 (it
has two boots), and /work/rootfs is the disk of that server. No
systemd runs in this container, so read the journal with
journalctl -D /work/journal ... and change the server's units with
systemctl --root=/work/rootfs ...

1. backup.service failed during the LAST boot of web1. Write the
   full path of the program it could not find to /work/missing.txt
   (only the path, like /usr/bin/example).
2. The program really is /usr/local/sbin/backup-run on that disk.
   Fix /work/rootfs/etc/systemd/system/backup.service and make sure
   it will start at every boot of web1. Leave nginx.service alone.

Check: sh /practice/check.sh     Answer: /practice/solution.md
