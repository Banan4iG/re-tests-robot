*** Settings ***
Library     OperatingSystem
Library     RemoteSwingLibrary
Library     help_func.py


*** Keywords ***
Setup Before Every Tests
    Backup Savedconnections File
    ${path_to_exe}=    Get Path
    # Log    ${path_to_exe}    console=True
    TRY
        Start Application    rdb_expert    ${path_to_exe}    timeout=20    remote_port=60900
        # Start Application    rdb_expert    java -javaagent:D:/re-tests-robot/lib/jacocoagent.jar=destfile=D:/re-tests-robot/results/jacoco.exec,output=file -jar D:/projects/RDBExpert/rdbexpert.jar -exe_path=D:/projects/RDBExpert/bin/RDBExpert.exe    timeout=20
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Log    RDBExpert failed to launch    console=True
        Kill Rdbexpert
    END

    Select Main Window

Teardown After Every Tests
    System Exit    0
    Unlock Employee
    Clear History Files
    Restore Savedconnections File

Open Connection
    Click On Tree Node    0    New Connection    2

Close Connection
    Select From Tree Node Popup Menu    0    New Connection    Disconnect

Connect To RDBExpert
    Application Started    rdb_expert    timeout=20    remote_port=60900
    Select Main Window

Skip If Embedded
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    Skip If    ${{$connect_type == 'embedded'}}
