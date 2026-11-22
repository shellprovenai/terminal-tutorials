#!/usr/bin/env python3
"""Local test API for the curl lesson (runs only inside the demo container, port 8000). No external services."""
import json, time
from http.server import BaseHTTPRequestHandler, HTTPServer

ITEMS = [{"id": 1, "name": "keyboard"}, {"id": 2, "name": "monitor"}]


class H(BaseHTTPRequestHandler):
    def send(self, code, obj, extra=None):
        body = (json.dumps(obj) + "\n").encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        for k, v in (extra or {}).items(): self.send_header(k, v)
        self.end_headers(); self.wfile.write(body)

    def log_message(self, *a): pass

    def do_GET(self):
        if self.path == "/health": return self.send(200, {"status": "ok"})
        if self.path == "/slow": time.sleep(0.4); return self.send(200, {"status": "ok", "slow": True})
        if self.path == "/api/items":
            if self.headers.get("Authorization") != "Bearer demo-token": return self.send(401, {"error": "missing or wrong token"})
            return self.send(200, ITEMS)
        if self.path == "/me":
            if "session=abc123" not in (self.headers.get("Cookie") or ""): return self.send(401, {"error": "not logged in"})
            return self.send(200, {"user": "demo"})
        return self.send(404, {"error": "not found"})

    def do_POST(self):
        n = int(self.headers.get("Content-Length") or 0); raw = self.rfile.read(n)
        if self.path == "/login": return self.send(200, {"logged_in": True}, {"Set-Cookie": "session=abc123; Path=/; HttpOnly"})
        if self.path == "/api/items":
            if self.headers.get("Content-Type", "").split(";")[0] != "application/json":
                return self.send(415, {"error": "expected Content-Type: application/json"})
            try: data = json.loads(raw)
            except ValueError: return self.send(400, {"error": "invalid JSON"})
            item = {"id": len(ITEMS) + 1, "name": data.get("name")}; ITEMS.append(item)
            return self.send(201, item)
        return self.send(404, {"error": "not found"})


HTTPServer(("127.0.0.1", 8000), H).serve_forever()
