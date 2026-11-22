# curl for APIs: headers, JSON bodies, timings, cookies, and the status code trap in scripts

> 🎬 Video: premieres on [youtube.com/@ShellProven](https://www.youtube.com/@ShellProven) (direct link added on release).

Commands from the video, tested in `docker.io/library/debian:13`. Run `setup.sh` first to recreate the demo folder.

> Script and narration made with the help of AI. Every command below was executed; outputs are real.

## Status codes and the exit code trap

```console
$ curl -s http://localhost:8000/health
{"status": "ok"}
```

```console
$ curl -si http://localhost:8000/health
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.5
Date: Sat, 21 Nov 2026 22:53:04 GMT
Content-Type: application/json
Content-Length: 17

{"status": "ok"}
```

```console
$ curl -s http://localhost:8000/nope; echo "curl exit code: $?"
{"error": "not found"}
curl exit code: 0
```

```console
$ curl -sf http://localhost:8000/nope; echo "curl exit code: $?"
curl exit code: 22
```

## Send a header

```console
$ curl -s -w ' -> %{http_code}\n' http://localhost:8000/api/items
{"error": "missing or wrong token"}
 -> 401
```

```console
$ curl -s -H "Authorization: Bearer demo-token" http://localhost:8000/api/items
[{"id": 1, "name": "keyboard"}, {"id": 2, "name": "monitor"}]
```

## POST a JSON body

```console
$ curl -s -w ' -> %{http_code}\n' -d '{"name":"cable"}' http://localhost:8000/api/items
{"error": "expected Content-Type: application/json"}
 -> 415
```

```console
$ curl -s -w ' -> %{http_code}\n' -H 'Content-Type: application/json' -d '{"name":"cable"}' http://localhost:8000/api/items
{"id": 3, "name": "cable"}
 -> 201
```

```console
$ curl -s -w ' -> %{http_code}\n' --json '{"name":"mouse"}' http://localhost:8000/api/items
{"id": 4, "name": "mouse"}
 -> 201
```

## Timings with -w

```console
$ curl -s -o /dev/null -w 'status %{http_code}, connect %{time_connect}s, total %{time_total}s\n' http://localhost:8000/slow
status 200, connect 0.000184s, total 0.401015s
```

## Keep a session with cookies

```console
$ curl -s -c cookies.txt -X POST http://localhost:8000/login
{"logged_in": true}
```

```console
$ curl -s http://localhost:8000/me; curl -s -b cookies.txt http://localhost:8000/me
{"error": "not logged in"}
{"user": "demo"}
```

## Check the status code in a script

```console
$ code=$(curl -s -o /tmp/body.json -w '%{http_code}' http://localhost:8000/nope); if [ "$code" != 200 ]; then echo "request failed with $code"; fi
request failed with 404
```

## Quick check

**Question 1.** curl gets a 404 Not Found. What exit code does it return without -f?

**Answer:** 0 — use -f or check %{http_code} — For curl, any answer is a success. -f turns error codes into exit code twenty-two.

**Question 2.** How do I POST JSON so the server knows it is JSON?

**Answer:** -H 'Content-Type: application/json' -d '{...}' (or --json) — Plain -d sends a form. The content type header, or --json, tells the server it's J S O N.

Commands that check the answers (run in the same container, after the lesson):

```console
$ curl -s http://localhost:8000/nope; echo "exit code: $?"
{"error": "not found"}
exit code: 0
```

```console
$ curl -sf http://localhost:8000/nope

```

```console
$ curl -s -w ' -> %{http_code}\n' -d '{"name":"x"}' http://localhost:8000/api/items
{"error": "expected Content-Type: application/json"}
 -> 415
```

```console
$ curl -s -w ' -> %{http_code}\n' --json '{"name":"x"}' http://localhost:8000/api/items
{"id": 5, "name": "x"}
 -> 201
```

## Files

- `setup.sh` — demo folder
- `curl-api.tape` — VHS tape (terminal recording script)
- `polecenia.log` — full test log with exit codes

License: <do decyzji Sewa>
