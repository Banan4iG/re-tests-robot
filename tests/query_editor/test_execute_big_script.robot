*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_execute_3
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '3.0'}}
    Init    test_script3.sql
    Sleep    10s

test_execute_5
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5.0'}}
    Init    test_script5.sql
    Sleep    5s

test_execute_26
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '2.6'}}
    Init    test_script26.sql
    Sleep    5s

test_cancel
    Init    test_script26.sql
    Sleep    0.5s
    Push Button    stop-execution-command
    Sleep    5s

*** Keywords ***
Init
    [Arguments]    ${file}
    Lock Employee
    Open connection
    Sleep    2s
    Clear Text Field    0
    Select From Main Menu    Edit|Open file
    Select Dialog    Open
    ${script_path}=    Catenate    SEPARATOR=    ${EXECDIR}    /files/${file}
    Type Into Text Field    0    ${script_path}
    Push Button    Open
    Select Main Window
    Run Keyword In Separate Thread    Push Button    execute-script-command