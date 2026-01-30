*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown


*** Test Cases ***
test_1
    Check Skip
    Lock Employee
    Open Connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    execute-in-profiler-command
    Sleep    3s
    Push Button    discardButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window

test_2
    Check Skip
    Lock Employee
    Open Connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM 123;
    Push Button    execute-in-profiler-command
    Sleep    3s
    Close Dialog    Warning

test_3
    Check Skip
    Lock Employee
    Open Connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM 123;
    Push Button    execute-in-profiler-command
    Sleep    0.5s
    Push Button    stop-execution-command


*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip If    ${{$ver != '5'}}
