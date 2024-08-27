import os
import platform
import shutil
import subprocess
import time
import tempfile
import firebird.driver as fdb
from firebird.driver import driver_config, connect_server, SrvInfoCode
from pathlib import Path

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
    COVERAGE = os.environ.get('COVERAGE')
    bin = "" if platform.system() == "Linux" else ".exe"
    if COVERAGE:
        path_to_exe = f"java -javaagent:./lib/jacocoagent.jar=destfile=./results/jacoco.exec,output=file -jar {DIST}/RedExpert.jar -exe_path={DIST}/bin/RedExpert64"
        return path_to_exe
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

    if os.path.exists(tmp_dir + '/RedExpert'):
        shutil.rmtree(tmp_dir + '/RedExpert')
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
    bin_dir = "bin/" if platform.system() == "Linux" else ""
    subprocess.run([f"{home_directory}{bin_dir}nbackup{bin}", "-L", f"{home_directory}examples/empbuild/employee.fdb", "-u", "SYSDBA", "-p", "masterkey"])
    time.sleep(1)

def unlock_employee():
    home_directory, version, srv_version = get_server_info()
    bin = "" if platform.system() == "Linux" else ".exe"
    bin_dir = "bin/" if platform.system() == "Linux" else ""
    delta_file = home_directory + "examples/empbuild/employee.fdb.delta"
    if os.path.exists(delta_file):
        time.sleep(5) 
        os.remove(delta_file)
        subprocess.run([f"{home_directory}{bin_dir}nbackup{bin}", "-F", f"{home_directory}examples/empbuild/employee.fdb"])

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

def delete_query_files():
    home_dir = os.path.expanduser("~")
    for path in Path(os.path.join(home_dir,'.redexpert/202406/QueryEditor')).glob("script*.sql"):
        os.remove(path)

def check_build_config(conf_path: str, number: int):
    check_dict = {}   
    check_dict["format"] = ["0", "0"]
    check_dict["enabled"] = ["true", "true"]
    check_dict["log_security_incidents"] = ["true", "false"]
    check_dict["log_initfini"] = ["true", "false"]
    check_dict["log_connections"] = ["true", "false"]
    check_dict["log_transactions"] = ["true", "false"]
    check_dict["log_statement_prepare"] = ["true", "false"]
    check_dict["log_statement_free"] = ["true", "false"]
    check_dict["log_statement_start"] = ["true", "false"]
    check_dict["log_statement_finish"] = ["true", "false"]
    check_dict["log_procedure_start"] = ["true", "false"]
    check_dict["log_procedure_finish"] = ["true", "false"]
    check_dict["log_function_start"] = ["true", "false"]
    check_dict["log_function_finish"] = ["true", "false"]
    check_dict["log_trigger_start"] = ["true", "false"]
    check_dict["log_service_query"] = ["true", "false"]
    check_dict["log_trigger_finish"] = ["false", "true"]
    check_dict["log_context"] = ["false", "true"]
    check_dict["log_errors"] = ["false", "true"]
    check_dict["log_warnings"] = ["false", "true"]
    check_dict["print_plan"] = ["false", "true"]
    check_dict["print_perf"] = ["false", "true"]
    check_dict["log_blr_requests"] = ["false", "true"]
    check_dict["print_blr"] = ["false", "true"]
    check_dict["log_dyn_requests"] = ["false", "true"]
    check_dict["print_dyn"] = ["false", "true"]
    check_dict["log_privilege_changes"] = ["false", "true"]
    check_dict["log_changes_only"] = ["false", "true"]
    check_dict["log_services"] = ["false", "true"]
    check_dict["include_user_filter"] = ["ship", "0"]
    check_dict["exclude_user_filter"] = ["819", "0"]
    check_dict["include_process_filter"] = ["14", "0"]
    check_dict["exclude_process_filter"] = ["true", "0"]
    check_dict["include_filter"] = ["0", "ship"]
    check_dict["exclude_filter"] = ["0", "819"]
    check_dict["connection_id"] = ["0", "14"]
    check_dict["log_filename"] = ["0", "true"]
    check_dict["max_log_size"] = ["1024", "0"]
    check_dict["time_threshold"] = ["2048", "0"]
    check_dict["max_sql_length"] = ["4096", "0"]
    check_dict["max_blr_length"] = ["8192", "0"]
    check_dict["max_dyn_length"] = ["0", "1024"]
    check_dict["max_arg_length"] = ["0", "2048"]
    check_dict["max_arg_count"] = ["0", "4096"]
    with open(conf_path, "r") as f:
        for i in range(3):
            f.readline()
        for i in range(38):
            first, equal, second = list(f.readline().split())
            assert check_dict[first][number] == second
            f.readline()
        for i in range(5):
            f.readline()
        for i in range(9):
            first, equal, second = list(f.readline().split())
            assert check_dict[first][number] == second
            f.readline()

def create_objects(rdb5: bool):
    set_config()
    with fdb.connect("employee") as con:
        #add objects
        con.execute_immediate("CREATE GLOBAL TEMPORARY TABLE NEW_GLOBAL_TEMPORARY_1 (TEST INTEGER) ON COMMIT DELETE ROWS;")
        con.execute_immediate("""
CREATE OR ALTER FUNCTION NEW_FUNC
RETURNS VARCHAR(5)
AS
begin
  RETURN 'five';
end
""")
        con.execute_immediate("CREATE PACKAGE NEW_PACK AS BEGIN END;")
        con.execute_immediate("RECREATE PACKAGE BODY NEW_PACK AS BEGIN END;")
        con.execute_immediate("""
CREATE OR ALTER TRIGGER NEW_DDL_TRIGGER
ACTIVE BEFORE ANY DDL STATEMENT  POSITION 0
AS
BEGIN
END
""")
        con.execute_immediate("""
CREATE OR ALTER TRIGGER NEW_DB_TRIGGER
ACTIVE ON CONNECT POSITION 0
AS
BEGIN
END
""")
        con.execute_immediate("""
DECLARE EXTERNAL FUNCTION NEW_UDF
RETURNS
BIGINT
ENTRY_POINT '123' MODULE_NAME '123'
""")
        con.execute_immediate("CREATE ROLE TEST_ROLE;")       
        con.execute_immediate("create collation iso8859_1_unicode for iso8859_1")

        #add comments
        con.execute_immediate("COMMENT ON DOMAIN EMPNO IS 'comment'")
        con.execute_immediate("COMMENT ON TABLE EMPLOYEE IS 'comment'")
        con.execute_immediate("COMMENT ON TABLE NEW_GLOBAL_TEMPORARY_1 IS 'comment'")
        con.execute_immediate("COMMENT ON VIEW PHONE_LIST IS 'comment'")
        con.execute_immediate("COMMENT ON PROCEDURE ADD_EMP_PROJ IS 'comment'")
        con.execute_immediate("COMMENT ON FUNCTION NEW_FUNC IS 'comment'")
        con.execute_immediate("COMMENT ON PACKAGE NEW_PACK IS 'comment'")
        con.execute_immediate("COMMENT ON TRIGGER POST_NEW_ORDER IS 'comment'")
        con.execute_immediate("COMMENT ON TRIGGER NEW_DDL_TRIGGER IS 'comment'")
        con.execute_immediate("COMMENT ON TRIGGER NEW_DB_TRIGGER IS 'comment'")
        con.execute_immediate("COMMENT ON SEQUENCE CUST_NO_GEN IS 'comment';")
        con.execute_immediate("COMMENT ON EXCEPTION CUSTOMER_CHECK IS 'comment'")
        con.execute_immediate("COMMENT ON EXTERNAL FUNCTION NEW_UDF IS 'comment'")
        con.execute_immediate("COMMENT ON ROLE TEST_ROLE IS 'comment'")
        con.execute_immediate("COMMENT ON INDEX CHANGEX IS 'comment'")
        
        if rdb5:
        #     con.execute_immediate("CREATE TABLESPACE NEW_TABLESPACE_1 FILE 'file.ts';")
            con.execute_immediate("""                                 
CREATE JOB NEW_JOB
'13 17 * * *'
INACTIVE
START DATE NULL
END DATE NULL
AS
begin
end
""")
        con.commit()

def delete_objects(rdb5: bool):
    with fdb.connect("employee") as con:

#         #remove objects
#         con.execute_immediate("DROP TABLE NEW_GLOBAL_TEMPORARY_1")
#         con.execute_immediate("DROP FUNCTION NEW_FUNC")
#         con.execute_immediate("DROP PACKAGE NEW_PACK")
#         con.execute_immediate("DROP TRIGGER NEW_DDL_TRIGGER")
#         con.execute_immediate("DROP TRIGGER NEW_DB_TRIGGER")
#         con.execute_immediate("DROP EXTERNAL FUNCTION NEW_UDF")
#         con.execute_immediate("DROP ROLE TEST_ROLE")
#         con.execute_immediate("DROP COLLATION iso8859_1_unicode")

#         #remove comment
#         con.execute_immediate("COMMENT ON DOMAIN EMPNO IS ''")
#         con.execute_immediate("COMMENT ON TABLE EMPLOYEE IS ''")
#         con.execute_immediate("COMMENT ON VIEW PHONE_LIST IS ''")
#         con.execute_immediate("COMMENT ON PROCEDURE ADD_EMP_PROJ IS ''")
#         con.execute_immediate("COMMENT ON TRIGGER POST_NEW_ORDER IS ''")
#         con.execute_immediate("COMMENT ON SEQUENCE CUST_NO_GEN IS ''")
#         con.execute_immediate("COMMENT ON EXCEPTION CUSTOMER_CHECK IS ''")
#         con.execute_immediate("COMMENT ON INDEX CHANGEX IS ''")

        if rdb5:
            # con.execute_immediate("DROP TABLESPACE NEW_TABLESPACE_1;")
            con.execute_immediate("DROP JOB NEW_JOB;")
            con.commit()

def delete_files(files: list):
	for file in files:
		if os.path.exists(file):
			os.remove(file)

def create_database(script_path: str, base_path: str):
    home_directory, version, srv_version = get_server_info()
    with open(script_path, "r") as file:
        context = file.read()
    
    context = context.replace("employee.fdb", base_path)
    
    with open(script_path, "w") as file:
        file.write(context)
    
    con = fdb.create_database(base_path)
    con.close()
    subprocess.call(f"{home_directory}\isql -q -i \"{script_path}\"")
	

#sql script
"""
DROP TABLE NEW_GLOBAL_TEMPORARY_1;
DROP FUNCTION NEW_FUNC;
DROP PACKAGE NEW_PACK;
DROP TRIGGER NEW_DDL_TRIGGER;
DROP TRIGGER NEW_DB_TRIGGER;
DROP EXTERNAL FUNCTION NEW_UDF;
DROP ROLE TEST_ROLE;
DROP COLLATION iso8859_1_unicode;
DROP TABLESPACE NEW_TABLESPACE_1;
DROP JOB NEW_JOB;
COMMENT ON DOMAIN EMPNO IS '';
COMMENT ON TABLE EMPLOYEE IS '';
COMMENT ON VIEW PHONE_LIST IS '';
COMMENT ON PROCEDURE ADD_EMP_PROJ IS '';
COMMENT ON TRIGGER POST_NEW_ORDER IS '';
COMMENT ON SEQUENCE CUST_NO_GEN IS '';
COMMENT ON EXCEPTION CUSTOMER_CHECK IS '';
COMMENT ON INDEX CHANGEX IS '';
"""