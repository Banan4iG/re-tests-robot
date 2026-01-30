*** Settings ***
Library     OperatingSystem
Library     RemoteSwingLibrary
Library     help_func.py


*** Keywords ***
Suite Setup
    Start RDB Expert

Test Setup
    # Backup Savedconnections File
    TRY
        Application Started    red_expert    timeout=1    remote_port=60900
    EXCEPT
        Start RDB Expert
    END
    Select Main Window
    Focus To Component    0

Start RDB Expert
    ${path_to_exe}=    Get Path
    # Log    ${path_to_exe}    console=True
    TRY
        Start Application    rdb_expert    ${path_to_exe}    timeout=20    remote_port=60900
        # Start Application    rdb_expert    java -javaagent:D:/re-tests-robot/lib/jacocoagent.jar=destfile=D:/re-tests-robot/results/jacoco.exec,output=file -jar D:/projects/RDBExpert/rdbexpert.jar -exe_path=D:/projects/RDBExpert/bin/RDBExpert.exe    timeout=20
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Kill Rdbexpert
        Fail    RDB Expert failed to launch
    END

Suite Teardown
    System Exit    0
    Kill Rdbexpert

Test Teardown
    Close All Dialogs
    Close connection
    Unlock Employee
    Clear History Files
    # Restore Savedconnections File    

Open Connection
    Click On Tree Node    0    New Connection    2
    
Close Connection
    Select Main Window
    # ${names}=    Get Tree Node Child Names    0    New Connection
    # IF    ${names}
    #     Click On Tree Node    0    New Connection    2
    # END
    Select From Tree Node Popup Menu    0    New Connection    Disconnect

Connect To RDBExpert
    Application Started    rdb_expert    timeout=20    remote_port=60900
    Select Main Window

Skip If Embedded
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    Skip If    ${{$connect_type == 'embedded'}}
