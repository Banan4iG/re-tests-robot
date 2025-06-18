from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
import json

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):

        def init_response(data: dict):
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            response_data = data
            self.wfile.write(json.dumps(response_data).encode())

        def init_data(version: str):
            data = {
                "base_url": "http://builds.red-soft.biz/release_hub/red_expert/",
                "version": f"{version}",
                "changelog": {
                "ru": "Добавлено:",
                "en": "Added:"
                },
                "files": [
                    {
                        "FILE_NAME": f"RedExpert-{version}.zip",
                        "FILE_PATH": "2025.06-SNAPSHOT.75/download/red_expert:bin:2025.06-SNAPSHOT.75:zip"
                    },]
            }
            return data

        url_path = self.path
        print(url_path)
        if "version=9999.98" in url_path:
            data = init_data("9999.98")
            init_response(data)

        elif "version=9999.99" in url_path:
            data = init_data("9999.99")
            init_response(data)        
        else:
            data = {
                "": "",
            } 
            init_response(data)

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler, port=443):
    server_address = ('localhost', port)
    httpd = server_class(server_address, handler_class)
    print(f"Starting httpd server on port {port}")
    return httpd

if __name__ == "__main__":
    try:
        httpd = run()
        httpd.serve_forever()
    except KeyboardInterrupt:
        httpd.server_close()