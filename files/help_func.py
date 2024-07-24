import os
import platform
import shutil
import subprocess
import time
import tempfile
import firebird.driver as fdb
from firebird.driver import driver_config, connect_server, SrvInfoCode

def run_server():
    PYTHON = os.environ.get('PYTHON')
    global p 
    p = subprocess.Popen([PYTHON, "./files/run_server.py"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    # p = Popen(["python", "./files/run_server.py"])
    time.sleep(5)

def stop_server():
    p.terminate()

def get_build_no():
    return "202406"

def bakup_user_properties():
    home_dir = os.path.expanduser("~")
    build_no = get_build_no()
    user_properties_file = os.path.join(home_dir, f'.redexpert/{build_no}/eq.user.properties')
    shutil.copy(user_properties_file, user_properties_file + ".bak")

def restore_user_properties():
    home_dir = os.path.expanduser("~")
    build_no = get_build_no()
    user_properties_file = os.path.join(home_dir, f'.redexpert/{build_no}/eq.user.properties')
    if os.path.exists(user_properties_file):
        os.remove(user_properties_file)
    shutil.move(user_properties_file + ".bak", user_properties_file)

def set_urls():
    home_dir = os.path.expanduser("~")
    build_no = get_build_no()
    user_properties_file = os.path.join(home_dir, f'.redexpert/{build_no}/eq.user.properties')
    with open(user_properties_file, 'r') as f:
        context = f.read()

    context += """
update.use.https=false
reddatabase.check.rc.url=http\://localhost
reddatabase.check.url=http\://localhost
reddatabase.get-files.url=http\://localhost/?project\=redexpert&version\="""

    with open(user_properties_file, 'w') as f:
        f.write(context)

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
    build_no = get_build_no()
    history_file = os.path.join(home_dir, f'.redexpert/{build_no}/ConnectionHistory.xml')
    saved_conn_file = os.path.join(home_dir, f'.redexpert/{build_no}/savedconnections.xml')
    if os.path.exists(saved_conn_file):
        with open(saved_conn_file, 'r') as f:
            context = f.read()
        
        if "</connection>" in context:
            context = context[:context.find("</connection>")] + "</connection>\n\n</savedconnections>"
        
            with open(saved_conn_file, 'w') as f:
                f.write(context)

    if os.path.exists(history_file):
        os.remove(history_file)

def copy_dist_path():
    DIST = os.environ.get('DIST')
    ARCH = os.environ.get('ARCH')
    # DIST = "D:/Program Files/RedExpert"
    tmp_dir = tempfile.gettempdir()
    global return_path
    return_path = shutil.copytree(DIST, tmp_dir + '/RedExpert')
    bin = "" if platform.system() == "Linux" else ".exe"
    path_to_exe = return_path + "/bin"
    if ARCH == "x86_64":
        path_to_exe += f"/RedExpert64{bin}" 
    else:
        path_to_exe += f"/RedExpert{bin}"
    return path_to_exe

def set_config():
    driver_config.server_defaults.host.value = 'localhost'
    driver_config.server_defaults.user.value = 'SYSDBA'
    driver_config.server_defaults.password.value = 'masterkey'


def get_server_info():
    global home_directory
    global version
    global srv_version

    set_config()
    
    with connect_server(server='localhost', user='SYSDBA', password='masterkey') as srv:
        home_directory = srv.info.home_directory
        for ver in ["3.0", "5.0"]:
            index = srv.info.version.find(ver)
            if index > -1:
                version = ver
                break

        for srv_ver in ["Firebird", "RedDatabase"]:
            index = srv.info.get_info(SrvInfoCode.SERVER_VERSION).find(srv_ver)
            if index > -1:
                srv_version = srv_ver
                break
        return home_directory, version, srv_version

def lock_employee():
    home_directory, version, srv_version = get_server_info()
    bin = "" if platform.system() == "Linux" else ".exe"
    subprocess.run([f"{home_directory}nbackup{bin}", "-L", f"{home_directory}examples/empbuild/employee.fdb", "-u", "SYSDBA", "-p", "masterkey"])
    time.sleep(1)

def unlock_employee():
    home_directory, version, srv_version = get_server_info()
    bin = "" if platform.system() == "Linux" else ".exe"
    delta_file = home_directory + "examples/empbuild/employee.fdb.delta"
    if os.path.exists(delta_file): 
        os.remove(delta_file)
        subprocess.run([f"{home_directory}nbackup{bin}", "-F", f"{home_directory}examples/empbuild/employee.fdb"])
        time.sleep(1)


def execute(query: str):
    set_config()
    with fdb.connect("employee") as con:
        cur = con.cursor()
        cur.execute(query)
        result = cur.fetchall()
        cur.close()
    return str(result)


def execute_immediate(query: str):
    set_config()
    with fdb.connect("employee") as con:
        con.execute_immediate(query)
        con.commit()