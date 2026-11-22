# SSH tunnels for your own server: -L, -R and -D, reach a database that only listens on localhost

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## A service that only listens on localhost

```console
$ ss -ltn 'sport = :5432'
State  Recv-Q Send-Q Local Address:Port Peer Address:Port
LISTEN 0      5          127.0.0.1:5432      0.0.0.0:*   
```

## Local forward: ssh -L

```console
$ ssh -f -N -L 15432:localhost:5432 deploy@localhost && ss -ltn 'sport = :15432'
State  Recv-Q Send-Q Local Address:Port  Peer Address:Port
LISTEN 0      128        127.0.0.1:15432      0.0.0.0:*   
LISTEN 0      128            [::1]:15432         [::]:*   
```

```console
$ socat - TCP:localhost:15432
db: hello from port 5432
```

```console
$ pkill -f "ssh -f -N -L 15432" && sleep 0.5; ss -ltn 'sport = :15432'
State Recv-Q Send-Q Local Address:Port Peer Address:Port
```

## Reverse forward: ssh -R

```console
$ ssh -f -N -R 9000:localhost:8000 deploy@localhost && curl -s http://localhost:9000/
preview of my local app
```

```console
$ ss -ltn 'sport = :9000'
State  Recv-Q Send-Q Local Address:Port Peer Address:Port
LISTEN 0      128        127.0.0.1:9000      0.0.0.0:*   
LISTEN 0      128            [::1]:9000         [::]:*   
```

```console
$ pkill -f "ssh -f -N -R 9000"

```

## SOCKS proxy: ssh -D

```console
$ ssh -f -N -D 1080 deploy@localhost && curl -s --socks5-hostname localhost:1080 http://localhost:8000/
preview of my local app
```

```console
$ pkill -f "ssh -f -N -D 1080"

```

## Make it permanent: LocalForward in ~/.ssh/config

```console
$ printf 'Host db-tunnel\n    HostName localhost\n    User deploy\n    LocalForward 15432 localhost:5432\n' >> ~/.ssh/config && chmod 600 ~/.ssh/config && cat ~/.ssh/config
Host db-tunnel
    HostName localhost
    User deploy
    LocalForward 15432 localhost:5432
```

```console
$ ssh -f -N db-tunnel && socat - TCP:localhost:15432
db: hello from port 5432
```

## Quick check

**Question 1.** My database listens only on 127.0.0.1 on my server. Which tunnel lets my laptop reach it?

**Answer:** ssh -L 15432:localhost:5432 user@server — A local forward opens a port on your side and connects to localhost as seen from the server.

**Question 2.** With ssh -R, who can connect to the forwarded port on the server by default?

**Answer:** Only programs on the server itself (127.0.0.1) — By default reverse ports bind to localhost on the server, so they stay private.

Commands that check the answers (run in the same container, after the lesson):

```console
$ socat - TCP:localhost:15432
db: hello from port 5432
```

```console
$ ssh -f -N -R 9000:localhost:8000 deploy@localhost && sleep 1 && ss -ltn 'sport = :9000' && pkill -f "ssh -f -N -R 9000"
State  Recv-Q Send-Q Local Address:Port Peer Address:Port
LISTEN 0      128        127.0.0.1:9000      0.0.0.0:*   
LISTEN 0      128            [::1]:9000         [::]:*   
```

## Files

- `setup.sh` — demo folder
- `ssh-tunnels.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
