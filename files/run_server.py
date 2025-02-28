from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
import json

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):

        def init_response(data = None):
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            response_data = data
            self.wfile.write(json.dumps(response_data).encode())

        url_path = self.path
        print(url_path)
        if "version" in url_path:
            data = [{
                "url": "http://localhost:443/file_link/",
                "filename": "bin/RedExpert-9999.99.zip",
            }]
            init_response(data)
        elif "genlink" in url_path:
            data = {
                "link": "http://builds.red-soft.biz/release_hub/red_expert/2023.10/download/red_expert:bin:2023.10:zip"
            }
            init_response(data)
        elif "project" in url_path:
            data = {
                "base_url": "http://builds.red-soft.biz",
                "version": "9999.99",
                "changelog": {
                "ru": "Добавлено:",
                "en": "Added:"
                },
                "files": [
                    {
                        "FILE_NAME": "RedExpert-9999.99.zip",
                        "FILE_PATH": "/release_hub/red_expert/2023.10/download/red_expert:bin:2023.10:zip"
                    },]

            }
            init_response(data)       
        else:
            data = {
                "version": "9999.99",
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