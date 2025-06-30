*** Settings ***
Library    RemoteSwingLibrary
Library    help_func.py


*** Keywords ***
Suite Setup
    Start Red Expert

Test Setup
    # Backup Savedconnections File
    TRY
        Application Started    red_expert    timeout=1    remote_port=60900
    EXCEPT
        Start Red Expert
    END
    Focus To Component    0
    
Start Red Expert
    ${path_to_exe}=    Get Path
        # Log    ${path_to_exe}    console=True
    TRY
        Start Application    red_expert    ${path_to_exe}    timeout=20    remote_port=60900
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Kill RedExpert
        Fail    Red Expert failed to launch
    END
    Select Main Window

Suite Teardown
    System Exit    0
    Kill Redexpert

Test Teardown
    Close All Dialogs
    Close connection
    Unlock Employee
    Clear History Files
    # Restore Savedconnections File    

Open connection
    Click On Tree Node    0    New Connection    2
    
Close connection
    Select Main Window
    ${names}=    Get Tree Node Child Names    0    New Connection
    IF    ${names}
        Click On Tree Node    0    New Connection    2
    END

Connect To Red Expert
    Application Started    red_expert    timeout=20    remote_port=60900
    Select Main Window