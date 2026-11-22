# curl for APIs: headers, JSON bodies, timings, cookies, and the status code trap in scripts
# ShellProven — nagrywane VHS; polecenia sprawdzone w docker.io/library/debian:13
# Uruchom w kontenerze: podman run --rm -it -v "$PWD:/w" -w /w ghcr.io/charmbracelet/vhs curl-api.tape
Output curl-api.mp4
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
Type `mkdir -p /lab/api && cd /lab/api && clear`
Enter
Type `echo IyEvdXNyL2Jpbi9lbnYgcHl0aG9uMwoiIiJMb2NhbCB0ZXN0IEFQSSBmb3IgdGhlIGN1cmwgbGVzc29uIChydW5zIG9ubHkgaW5zaWRlIHRoZSBkZW1vIGNvbnRhaW5lciwgcG9ydCA4MDAwKS4gTm8gZXh0ZXJuYWwgc2VydmljZXMuIiIiCmltcG9ydCBqc29uLCB0aW1lCmZyb20gaHR0cC5zZXJ2ZXIgaW1wb3J0IEJhc2VIVFRQUmVxdWVzdEhhbmRsZXIsIEhUVFBTZXJ2ZXIKCklURU1TID0gW3siaWQiOiAxLCAibmFtZSI6ICJrZXlib2FyZCJ9LCB7ImlkIjogMiwgIm5hbWUiOiAibW9uaXRvciJ9XQoKCmNsYXNzIEgoQmFzZUhUVFBSZXF1ZXN0SGFuZGxlcik6CiAgICBkZWYgc2VuZChzZWxmLCBjb2RlLCBvYmosIGV4dHJhPU5vbmUpOgogICAgICAgIGJvZHkgPSAoanNvbi5kdW1wcyhvYmopICsgIlxuIikuZW5jb2RlKCkKICAgICAgICBzZWxmLnNlbmRfcmVzcG9uc2UoY29kZSkKICAgICAgICBzZWxmLnNlbmRfaGVhZGVyKCJDb250ZW50LVR5cGUiLCAiYXBwbGljYXRpb24vanNvbiIpCiAgICAgICAgc2VsZi5zZW5kX2hlYWRlcigiQ29udGVudC1MZW5ndGgiLCBzdHIobGVuKGJvZHkpKSkKICAgICAgICBmb3IgaywgdiBpbiAoZXh0cmEgb3Ige30pLml0ZW1zKCk6IHNlbGYuc2VuZF9oZWFkZXIoaywgdikKICAgICAgICBzZWxmLmVuZF9oZWFkZXJzKCk7IHNlbGYud2ZpbGUud3JpdGUoYm9keSkKCiAgICBkZWYgbG9nX21lc3NhZ2Uoc2VsZiwgKmEpOiBwYXNzCgogICAgZGVmIGRvX0dFVChzZWxmKToKICAgICAgICBpZiBzZWxmLnBhdGggPT0gIi9oZWFsdGgiOiByZXR1cm4gc2VsZi5zZW5kKDIwMCwgeyJzdGF0dXMiOiAib2sifSkKICAgICAgICBpZiBzZWxmLnBhdGggPT0gIi9zbG93IjogdGltZS5zbGVlcCgwLjQpOyByZXR1cm4gc2VsZi5zZW5kKDIwMCwgeyJzdGF0dXMiOiAib2siLCAic2xvdyI6IFRydWV9KQogICAgICAgIGlmIHNlbGYucGF0aCA9PSAiL2FwaS9pdGVtcyI6CiAgICAgICAgICAgIGlmIHNlbGYuaGVhZGVycy5nZXQoIkF1dGhvcml6YXRpb24iKSAhPSAiQmVhcmVyIGRlbW8tdG9rZW4iOiByZXR1cm4gc2VsZi5zZW5kKDQwMSwgeyJlcnJvciI6ICJtaXNzaW5nIG9yIHdyb25nIHRva2VuIn0pCiAgICAgICAgICAgIHJldHVybiBzZWxmLnNlbmQoMjAwLCBJVEVNUykKICAgICAgICBpZiBzZWxmLnBhdGggPT0gIi9tZSI6CiAgICAgICAgICAgIGlmICJzZXNzaW9uPWFiYzEyMyIgbm90IGluIChzZWxmLmhlYWRlcnMuZ2V0KCJDb29raWUiKSBvciAiIik6IHJldHVybiBzZWxmLnNlbmQoNDAxLCB7ImVycm9yIjogIm5vdCBsb2dnZWQgaW4ifSkKICAgICAgICAgICAgcmV0dXJuIHNlbGYuc2VuZCgyMDAsIHsidXNlciI6ICJkZW1vIn0pCiAgICAgICAgcmV0dXJuIHNlbGYuc2VuZCg0MDQsIHsiZXJyb3IiOiAibm90IGZvdW5kIn0pCgogICAgZGVmIGRvX1BPU1Qoc2VsZik6CiAgICAgICAgbiA9IGludChzZWxmLmhlYWRlcnMuZ2V0KCJDb250ZW50LUxlbmd0aCIpIG9yIDApOyByYXcgPSBzZWxmLnJmaWxlLnJlYWQobikKICAgICAgICBpZiBzZWxmLnBhdGggPT0gIi9sb2dpbiI6IHJldHVybiBzZWxmLnNlbmQoMjAwLCB7ImxvZ2dlZF9pbiI6IFRydWV9LCB7IlNldC1Db29raWUiOiAic2Vzc2lvbj1hYmMxMjM7IFBhdGg9LzsgSHR0cE9ubHkifSkKICAgICAgICBpZiBzZWxmLnBhdGggPT0gIi9hcGkvaXRlbXMiOgogICAgICAgICAgICBpZiBzZWxmLmhlYWRlcnMuZ2V0KCJDb250ZW50LVR5cGUiLCAiIikuc3BsaXQoIjsiKVswXSAhPSAiYXBwbGljYXRpb24vanNvbiI6CiAgICAgICAgICAgICAgICByZXR1cm4gc2VsZi5zZW5kKDQxNSwgeyJlcnJvciI6ICJleHBlY3RlZCBDb250ZW50LVR5cGU6IGFwcGxpY2F0aW9uL2pzb24ifSkKICAgICAgICAgICAgdHJ5OiBkYXRhID0ganNvbi5sb2FkcyhyYXcpCiAgICAgICAgICAgIGV4Y2VwdCBWYWx1ZUVycm9yOiByZXR1cm4gc2VsZi5zZW5kKDQwMCwgeyJlcnJvciI6ICJpbnZhbGlkIEpTT04ifSkKICAgICAgICAgICAgaXRlbSA9IHsiaWQiOiBsZW4oSVRFTVMpICsgMSwgIm5hbWUiOiBkYXRhLmdldCgibmFtZSIpfTsgSVRFTVMuYXBwZW5kKGl0ZW0pCiAgICAgICAgICAgIHJldHVybiBzZWxmLnNlbmQoMjAxLCBpdGVtKQogICAgICAgIHJldHVybiBzZWxmLnNlbmQoNDA0LCB7ImVycm9yIjogIm5vdCBmb3VuZCJ9KQoKCkhUVFBTZXJ2ZXIoKCIxMjcuMC4wLjEiLCA4MDAwKSwgSCkuc2VydmVfZm9yZXZlcigpCg== | base64 -d > /opt/api.py`
Enter
Type `(setsid python3 /opt/api.py >/dev/null 2>&1 &); sleep 1`
Enter
Type `clear`
Enter
Show

# --- Status codes and the exit code trap
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Status codes and the exit code trap`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `curl -s http://localhost:8000/health`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4255ms
Sleep 300ms
Type `curl -si http://localhost:8000/health`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4322ms
Sleep 300ms
Type `curl -s http://localhost:8000/nope; echo "curl exit code: $?"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3048ms
Sleep 12193ms
Sleep 300ms
Type `curl -sf http://localhost:8000/nope; echo "curl exit code: $?"`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3414ms

# --- Send a header
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Send a header`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `curl -s -w ' -> %{http_code}\n' http://localhost:8000/api/items`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2152ms
Sleep 300ms
Type `curl -s -H "Authorization: Bearer demo-token" http://localhost:8000/api/items`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2210ms
Sleep 9106ms

# --- POST a JSON body
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# POST a JSON body`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `curl -s -w ' -> %{http_code}\n' -d '{"name":"cable"}' http://localhost:8000/api/items`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 3106ms
Sleep 300ms
Type `curl -s -w ' -> %{http_code}\n' -H 'Content-Type: application/json' -d '{"name":"cable"}' http://localhost:8000/api/items`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2413ms
Sleep 300ms
Type `curl -s -w ' -> %{http_code}\n' --json '{"name":"mouse"}' http://localhost:8000/api/items`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4610ms

# --- Timings with -w
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Timings with -w`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `curl -s -o /dev/null -w 'status %{http_code}, connect %{time_connect}s, total %{time_total}s\n' http://localhost:8000/slow`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4869ms
Sleep 6545ms

# --- Keep a session with cookies
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Keep a session with cookies`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `curl -s -c cookies.txt -X POST http://localhost:8000/login`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 4336ms
Sleep 300ms
Type `curl -s http://localhost:8000/me; curl -s -b cookies.txt http://localhost:8000/me`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 2221ms

# --- Check the status code in a script
Hide
Type `clear`
Enter
Show
Set TypingSpeed 15ms
Type `# Check the status code in a script`
Enter
Sleep 900ms
Set TypingSpeed 40ms
Sleep 300ms
Type `code=$(curl -s -o /tmp/body.json -w '%{http_code}' http://localhost:8000/nope); if [ "$code" != 200 ]; then echo "request failed with $code"; fi`
Sleep 300ms
Enter
Wait@20s /\$$/
Sleep 1599ms
Sleep 7127ms
