import os
import platform

def get_path():
    DIST = os.environ.get('DIST')
    ARCH = os.environ.get('ARCH')
    bin = "" if platform.system() == "Linux" else ".exe"
    if DIST:
        path_to_exe = DIST + "/bin"
        if ARCH == "x86_64":
            path_to_exe += f"/RedExpert64{bin}" 
        else:
            path_to_exe += f"/RedExpert{bin}"
    else:
        path_to_exe = '"C:\\Program Files\\RedExpert\\bin\\RedExpert64.exe"'

    return path_to_exe

def clear_history_files():
    home_dir = os.path.expanduser("~")
    build_no = "202406"

    history_file = os.path.join(home_dir,f'.redexpert/{build_no}/ConnectionHistory.xml')
    saved_conn_file = os.path.join(home_dir,f'.redexpert/{build_no}/savedconnections.xml')
    if os.path.exists(saved_conn_file):
        with open(saved_conn_file, 'r') as f:
            context = f.read()
        
        if "</connection>" in context:
            context = context[:context.find("</connection>")] + "</connection>\n\n</savedconnections>"
        
            with open(saved_conn_file, 'w') as f:
                f.write(context)

    if os.path.exists(history_file):
        os.remove(history_file)