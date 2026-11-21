# SSH keys from scratch: generate, install, shortcut with ~/.ssh/config, turn off passwords

> 🎬 Video: premieres Nov 25, 2026 on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `localhost/shellproven-ssh-keys:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## 1. Generate a key

```console
$ ssh-keygen -t ed25519 -C "laptop" -f ~/.ssh/id_ed25519 -N ""
Generating public/private ed25519 key pair.
Your identification has been saved in /root/.ssh/id_ed25519
Your public key has been saved in /root/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:qI0au6ZY7D4j2PLAA7RwSxQI1Y0/cBBOHuP9d/v7VBo laptop
The key's randomart image is:
+--[ED25519 256]--+
|oo+o*=           |
|.. =++o          |
|..o ++.          |
|oo..  oo         |
|...   ..S . . E .|
|o.   +   . . . o.|
|o++ o .     . . .|
|=+*+         . . |
|oBB+          oo.|
+----[SHA256]-----+
```

```console
$ ls -l ~/.ssh
total 8
-rw------- 1 root root 399 Nov 21 15:40 id_ed25519
-rw-r--r-- 1 root root  88 Nov 21 15:40 id_ed25519.pub
```

## 2. Install the public key on the server

```console
$ install -d -m 700 -o deploy -g deploy /home/deploy/.ssh && install -m 600 -o deploy -g deploy ~/.ssh/id_ed25519.pub /home/deploy/.ssh/authorized_keys

```

```console
$ ssh -o StrictHostKeyChecking=accept-new deploy@localhost whoami
Warning: Permanently added 'localhost' (ED25519) to the list of known hosts.
deploy
```

## 3. Why key login suddenly stops working

```console
$ chmod 777 /home/deploy && ssh -o BatchMode=yes deploy@localhost whoami
deploy@localhost: Permission denied (publickey,password).
```

```console
$ chmod 700 /home/deploy && ssh -o BatchMode=yes deploy@localhost whoami
deploy
```

## 4. A shortcut in ~/.ssh/config

```console
$ printf 'Host web\n    HostName localhost\n    User deploy\n    IdentityFile ~/.ssh/id_ed25519\n' > ~/.ssh/config && chmod 600 ~/.ssh/config

```

```console
$ cat ~/.ssh/config
Host web
    HostName localhost
    User deploy
    IdentityFile ~/.ssh/id_ed25519
```

```console
$ ssh web 'whoami; hostname'
deploy
demo
```

## 5. Turn off password logins

```console
$ sshd -T | grep -i '^passwordauthentication'
passwordauthentication yes
```

```console
$ echo 'PasswordAuthentication no' > /etc/ssh/sshd_config.d/10-no-passwords.conf && sshd -t && echo config OK
config OK
```

```console
$ kill -HUP "$(cat /run/sshd.pid)" && sleep 1 && sshd -T | grep -i '^passwordauthentication'
passwordauthentication no
```

```console
$ ssh -o PubkeyAuthentication=no -o BatchMode=yes deploy@localhost true
deploy@localhost: Permission denied (publickey).
```

```console
$ ssh web 'echo key login still works'
key login still works
```

## Files

- `setup.sh` — demo folder
- `ssh-keys.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
