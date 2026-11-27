# Solution — lesson 20 practice

**Part 1: POST JSON with an API key.** `-H "X-API-Key: $(cat /work/api-key.txt)"` reads the key from the file, so it
doesn't end up in your shell history. `--json` sends the body and sets `Content-Type: application/json` (on older curl:
`-H 'Content-Type: application/json' -d '...'`). Plain `-d` sends a form, and this server answers 415.
`-w ' -> %{http_code}\n'` shows the status: 201 means created.

**Part 2: make the script notice errors.** curl exits with 0 whenever the server answers, even with 404, so
`curl ... && echo "backup OK"` always says OK. `-f` makes curl exit with 22 on codes of 400 and above, so the `&&` stops
and the script exits non-zero. (Checking `code=$(curl -s -o file -w '%{http_code}' "$URL")` against 200 works too.)

```sh
curl -s -w ' -> %{http_code}\n' -H "X-API-Key: $(cat /work/api-key.txt)" --json '{"title":"disk full on web1"}' http://localhost:8080/tickets
sed -i 's/curl -s /curl -sf /' /work/backup-check.sh
```

Then run `sh /practice/check.sh`: all checks should say PASS.
