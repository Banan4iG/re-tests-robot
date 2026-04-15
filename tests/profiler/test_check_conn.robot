*** Settings ***
Library             Collections
Library             RemoteSwingLibrary
Library             os
Library             platform
Resource            ../../files/keywords.resource
Resource            keys.resource

Test Setup          Setup
Test Teardown       Teardown


*** Test Cases ***
test_re
    Init
    ${dist}=    Get Environment Variable    DIST    D:\\projects\\RDBExpert
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Type Into Text Field    roleField    TEST_ROLE
    Clear Text Field    userField
    Type Into Text Field    userField    TEST_USER
    Clear Text Field    passwordField
    Type Into Text Field    passwordField    123
    Push Button    saveButton
    Push Button    connectButton
    Open Connection
    Check    127.0.0.1    ${dist}

    Select Main Window
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection (Copy)    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes

test_isql
    Skip
    Init
    ${info}=    Get Server Info
    VAR    ${home_dir}=    ${info}[0]
    ${system}=    platform.System
    IF    ${{$system == 'Linux'}}
        VAR    ${dist}=    ${home_dir}/bin/isql
    ELSE
        VAR    ${dist}=    ${home_dir}/isql.exe
    END
    Run Isql
    Open Connection
    Check    ::1    ${dist}
    Stop Server


*** Keywords ***
Init
    Lock Employee
    Execute Immediate    CREATE ROLE TEST_ROLE;
    Execute Immediate    CREATE USER TEST_USER PASSWORD '123';
    Execute Immediate    GRANT TEST_ROLE TO TEST_USER;

Teardown
    Close All Dialogs
    Close All Tabs
    Close Connection
    IF    ${{$TEST_STATUS == 'FAIL'}}
        Sleep    0.5s
        VAR    ${file_name}=    ${{$SUITE_NAME.replace(' ', '_') + '_' + $TEST_NAME}}
        Take Screenshot    ${file_name}    1080
        Take Dump    ${OUTPUT_DIR}${/}${file_name}
        Kill Rdbexpert
        Sleep    0.5s
        Unlock Employee
        Clear History Files
        Restore Savedconnections File
    ELSE
        Execute Immediate    REVOKE TEST_ROLE FROM TEST_USER;
        Execute Immediate    DROP USER TEST_USER;
        Execute Immediate    DROP ROLE TEST_ROLE;
        Unlock Employee
    END

Check
    [Arguments]    ${ip}    ${dist}
    ${name}=    os.Getlogin
    ${host}=    platform.Node
    Select From Main Menu    Tools|Profiler
    Select From Combo Box    connectionCombo    New Connection
    Push Button    attachmentButton
    Sleep    2s
    Select Dialog    Select Attachment
    @{values}=    Get Table Values    attachmentsTable

    VAR    ${count}=    ${{len($values)}}
    Should Be Equal As Integers    ${count}    2    msg=В списке недостоточно коннектов

    Sort List    ${values}

    Should Not Be Equal As Integers    ${{$values[0][1].find('${ip}')}}    -1
    Should Be Equal As Strings
    ...    ${values}[0][2:]
    ...    ['TEST_USER', 'TEST_ROLE', '${host}', '${name}', '${dist}']
    ...    ignore_case=${True}

    Should Not Be Equal As Integers    ${{$values[1][1].find('127.0.0.1')}}    -1
    Should Be Equal As Strings    ${values}[1][2:]    ['SYSDBA', 'NONE', '${host}', '${name}', '${dist}']

    Close Dialog    Select Attachment

Setup
    Skip If Embedded
    Local Setup
