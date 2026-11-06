"""Local dev server. API GATEWAY will handle this."""
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "src"))
import handler  # noqa: E402


class LocalRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        path = self.path.split("?")[0]
        event = {"routeKey": f"GET {path}"}
        result = handler.lambda_handler(event, None)

        self.send_response(result["statusCode"])
        for name, value in result["headers"].items():
            self.send_header(name, value)
        self.end_headers()
        self.wfile.write(result["body"].encode())


if __name__ == "__main__":
    print("Listening on http://localhost:8000  (Ctrl+C to stop)")
    HTTPServer(("localhost", 8000), LocalRequestHandler).serve_forever()