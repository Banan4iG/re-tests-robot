*** Settings ***
Library    RemoteSwingLibrary
Library    help_func.py


*** Keywords ***
Setup before every tests
    Backup Savedconnections File
    ${path_to_exe}=    Get Path
    # Log    ${path_to_exe}    console=True
    TRY
        Start Application    red_expert    ${path_to_exe}    timeout=20    remote_port=60900
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Log    Red Expert failed to launch    console=True
        Kill RedExpert
    END

    Select Window    regexp=^Red.*

Teardown after every tests
    System Exit    0
    Unlock Employee
    Clear History Files
    Restore Savedconnections File        

Open connection
    Click On Tree Node    0    New Connection    2

Connect To Red Expert
    Application Started    red_expert    timeout=20    remote_port=60900
    Select Main Window