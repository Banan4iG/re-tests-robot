*** Settings ***
Library             String
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Init Conn
Test Teardown       Local Teardown


*** Variables ***
${db_path}      ${EMPTY}


*** Test Cases ***
test_no_use_default
    Push Button    No
    Select Main Window
    Close Dialog    Error message

test_yes_use_default
    Push Button    Yes
    Sleep    2s
    Select Main Window
    Expand All Tree Nodes    0
    Tree Node Should Not Be Leaf    0    New Connection


*** Keywords ***
Init Conn
    TRY
        System Exit    0
    EXCEPT
        Log    App is not run
    END
    Clear History Files
    Restore Savedconnections File
    Restore User Properties
    Backup Savedconnections File
    ${build_no}=    Get Build No
    ${home_dir}=    Normalize Path    ~
    VAR    ${saved_connection_path}=    ${home_dir}${/}.rdbexpert${/}${build_no}${/}connection-saved.xml
    ${content}=    Get File    ${saved_connection_path}
    ${new_content}=    Replace String    ${content}    <driverid>5555555</driverid>    <driverid>4444444</driverid>
    Create File    ${saved_connection_path}    ${new_content}

    ${path_to_exe}=    Get Path
    TRY
        Start Application    rdb_expert    ${path_to_exe}    timeout=20    remote_port=60900
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Log    RDBExpert failed to launch    console=True
        Kill Rdbexpert
    END
    Select Main Window

    Run Keyword In Separate Thread    Select From Tree Node Popup Menu    0    New Connection    Connect
    Select Dialog    Confirmation

    Label Text Should Be    0    The driver specified for connection "New Connection" does not exist, use the
    Label Text Should Be    1    default driver (RedDatabase JDBC Driver 5)?

Local Teardown
    System Exit    0
    Clear History Files
    Restore Savedconnections File
    Restore User Properties
