# "Address already in use": find which process holds a port (ss, lsof, fuser) and free it

> 🎬 Video: https://youtu.be/srChWgDNCsU (public from Nov 24, 2026)

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## The error

```console
$ socat TCP-LISTEN:8080 -
2026/11/21 21:31:49 socat[45] E bind(5, {AF=2 0.0.0.0:8080}, 16): Address already in use
```

## ss: who is listening

```console
$ ss -ltnp
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                       
LISTEN 0      5            0.0.0.0:8080      0.0.0.0:*    users:(("socat",pid=43,fd=5))
```

```console
$ ss -ltnp 'sport = :8080'
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                       
LISTEN 0      5            0.0.0.0:8080      0.0.0.0:*    users:(("socat",pid=43,fd=5))
```

## lsof and fuser

```console
$ lsof -i :8080
COMMAND PID USER FD   TYPE  DEVICE SIZE/OFF NODE NAME
socat    43 root 5u  IPv4 1034843      0t0  TCP *:8080 (LISTEN)
```

```console
$ fuser 8080/tcp
8080/tcp:               43
```

```console
$ lsof -t -i :8080
43
```

## Free the port with kill

```console
$ kill $(lsof -t -i :8080); sleep 0.5; ss -ltn 'sport = :8080'
State Recv-Q Send-Q Local Address:Port Peer Address:Port
```

```console
$ (setsid socat TCP-LISTEN:8080,fork SYSTEM:'echo hello' >/dev/null 2>&1 &); sleep 1; ss -ltnp 'sport = :8080'
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                       
LISTEN 0      5            0.0.0.0:8080      0.0.0.0:*    users:(("socat",pid=94,fd=5))
```

## The trap: fuser -k sends SIGKILL

```console
$ kill $(lsof -t -i :8080); sleep 0.5; (setsid sh -c 'socat TCP-LISTEN:8080,fork SYSTEM:true >/dev/null 2>&1; echo "exit status $?" > /tmp/exit.txt' &); sleep 1

```

```console
$ fuser -k 8080/tcp; sleep 1; cat /tmp/exit.txt
8080/tcp:              114
exit status 137
```

```console
$ (setsid sh -c 'socat TCP-LISTEN:8080,fork SYSTEM:true >/dev/null 2>&1; echo "exit status $?" > /tmp/exit.txt' &); sleep 1; fuser -k -TERM 8080/tcp; sleep 1; cat /tmp/exit.txt
8080/tcp:              121
exit status 143
```

## Quick check

**Question 1.** Which command shows the process listening on port 8080?

**Answer:** ss -ltnp 'sport = :8080' — ss -ltnp lists listening TCP sockets with their process. Grepping ps for the number won't find a port.

**Question 2.** Which signal does fuser -k send by default?

**Answer:** SIGKILL (use fuser -k -TERM) — SIGKILL, exit status one three seven. Add -TERM to let the program shut down cleanly.

Commands that check the answers (run in the same container, after the lesson):

```console
$ (setsid socat TCP-LISTEN:8080,fork SYSTEM:'echo hello' >/dev/null 2>&1 &); sleep 1; ss -ltnp 'sport = :8080'
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                        
LISTEN 0      5            0.0.0.0:8080      0.0.0.0:*    users:(("socat",pid=139,fd=5))
```

```console
$ kill $(lsof -t -i :8080); sleep 0.5; (setsid sh -c 'socat TCP-LISTEN:8080,fork SYSTEM:true >/dev/null 2>&1; echo "exit status $?" > /tmp/exit.txt' &); sleep 1; fuser -k 8080/tcp; sleep 1; cat /tmp/exit.txt
8080/tcp:              147
exit status 137
```

## Files

- `setup.sh` — demo folder
- `port-in-use.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
