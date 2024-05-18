def get_path():
    import os
    DIST = os.environ.get('DIST')
    ARCH = os.environ.get('ARCH')
    if DIST:
        path_to_exe = DIST + "\\bin"
        if ARCH == "x86_64":
            path_to_exe += "\\RedExpert64.exe" 
        else:
            path_to_exe += "\\RedExpert.exe"
    else:
        path_to_exe = '"C:\\Program Files\\RedExpert\\bin\\RedExpert64.exe"'

    return path_to_exe