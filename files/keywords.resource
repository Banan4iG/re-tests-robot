*** Settings ***
Library     OperatingSystem
Library     RemoteSwingLibrary
Library     help_func.py


*** Keywords ***
Suite Setup
    Start RDB Expert

Test Setup
    Backup Savedconnections File
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
    Select Main Window
    Close All Dialogs
    Close All Tabs
    Close Connection
    Unlock Employee
    IF    ${{$TEST_STATUS == 'FAIL'}}
        System Exit    0
        Kill Rdbexpert
        Clear History Files
        Restore Savedconnections File
    END

Open Connection
    Click On Tree Node    0    New Connection    2

Close Connection
    Select Main Window
    Set Jemmy Timeouts    200ms
    ${names}=    Get Tree Node Child Names    0    New Connection
    IF    ${names}
       Select From Tree Node Popup Menu    0    New Connection    Disconnect
    END
    Set Jemmy Timeouts    5

Connect To RDBExpert
    Application Started    rdb_expert    timeout=20    remote_port=60900
    Select Main Window

Skip If Embedded
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    Skip If    ${{$connect_type == 'embedded'}}

Close All Tabs
    Select Main Window
    VAR    ${expression}=    ${True}
    ${old}=    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    200ms
    WHILE    ${expression}
        TRY
            Click On Component    regexp=^closeTabLabel for.*
        EXCEPT
            VAR    ${expression}=    ${False}
        END
    END
    Set Jemmy Timeout    ComponentOperator.WaitComponentTimeout    ${old}

Change Prompt Save
    Select Main Window
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    General
    ${row}=    Find Table Row    0    Prompt to save open documents
    @{values}=    Get Table Values    0
    Click On Table Cell    0    ${row}    2
    Click On Tree Node    0    General
    Sleep    10s
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window
