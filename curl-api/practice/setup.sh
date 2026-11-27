#!/bin/sh
# setup.sh — starts a small helpdesk test API on 127.0.0.1:8080 (only inside this container, nothing leaves it)
# and writes /work/api-key.txt and /work/backup-check.sh (a nightly check script with a bug).
# Meant to run inside the throwaway container from start.sh. Only touches /work, /opt/practice-api.py and the server it started.
set -e
W=${WORK:-/work}
mkdir -p "$W"
# stop a server left from an earlier run (start over = fresh state)
if [ -f /tmp/practice-api.pid ]; then kill "$(cat /tmp/practice-api.pid)" 2>/dev/null || true; sleep 0.5; fi
rm -f /tmp/practice-api.pid "$W/api-key.txt" "$W/backup-check.sh" "$W/latest.json"
cat > /opt/practice-api.py <<'EOF'
#!/usr/bin/env python3
"""Practice API for the curl lesson: listens only on 127.0.0.1:8080 inside the practice container."""
import json, os
from http.server import BaseHTTPRequestHandler, HTTPServer

KEY = "k-7f3a9c"
TICKETS = []
STATS = {"401": 0, "415": 0, "400": 0}
BACKUPS = {"web1": {"host": "web1", "file": "web1-2026-11-25.tar.gz", "size_mb": 812}}


class H(BaseHTTPRequestHandler):
    def send(self, code, obj):
        if str(code) in STATS: STATS[str(code)] += 1
        body = (json.dumps(obj) + "\n").encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers(); self.wfile.write(body)

    def log_message(self, *a): pass

    def do_GET(self):
        if self.path == "/health": return self.send(200, {"status": "ok"})
        if self.path == "/_stats": return self.send(200, STATS)
        if self.path.startswith("/backups/"):
            b = BACKUPS.get(self.path.split("/")[2])
            return self.send(200, b) if b else self.send(404, {"error": "no backup found"})
        if self.path == "/tickets":
            if self.headers.get("X-API-Key") != KEY: return self.send(401, {"error": "missing or wrong X-API-Key"})
            return self.send(200, TICKETS)
        return self.send(404, {"error": "not found"})

    def do_POST(self):
        n = int(self.headers.get("Content-Length") or 0); raw = self.rfile.read(n)
        if self.path == "/tickets":
            if self.headers.get("X-API-Key") != KEY: return self.send(401, {"error": "missing or wrong X-API-Key"})
            if self.headers.get("Content-Type", "").split(";")[0] != "application/json":
                return self.send(415, {"error": "expected Content-Type: application/json"})
            try: data = json.loads(raw)
            except ValueError: return self.send(400, {"error": "invalid JSON"})
            if not isinstance(data, dict) or not data.get("title"): return self.send(400, {"error": "field title is required"})
            t = {"id": 100 + len(TICKETS) + 1, "title": data["title"], "status": "open"}; TICKETS.append(t)
            return self.send(201, t)
        return self.send(404, {"error": "not found"})


with open("/tmp/practice-api.pid", "w") as f: f.write(str(os.getpid()))
HTTPServer(("127.0.0.1", 8080), H).serve_forever()
EOF
(setsid python3 /opt/practice-api.py >/dev/null 2>&1 &)
for i in $(seq 1 30); do curl -s http://localhost:8080/health >/dev/null 2>&1 && break; sleep 0.2; done
echo "k-7f3a9c" > "$W/api-key.txt"
cat > "$W/backup-check.sh" <<'EOF'
#!/bin/sh
# backup-check.sh — nightly check: is there a backup of db1 on the backup server?
URL=${BACKUP_URL:-http://localhost:8080/backups/db1}
curl -s "$URL" -o /work/latest.json && echo "backup OK"
EOF
chmod +x "$W/backup-check.sh"
echo
cat /practice/TASK.md 2>/dev/null || true
