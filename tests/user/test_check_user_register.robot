*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Teardown


*** Test Cases ***
test_1
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Execute Immediate    CREATE USER "DEMO" PASSWORD 'pass'
    Execute Immediate    CREATE USER "dEmO" PASSWORD 'pass'
    Open Connection
    Expand Tree Node    0    New Connection
    ${res1}=    Check User    DEMO
    Select Main Window
    ${res2}=    Check User    dEmO
    Should Be Equal As Strings
    ...    ${res1}
    ...    CREATE USER DEMO ACTIVE USING PLUGIN Srp;
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}
    Should Be Equal As Strings
    ...    ${res2}
    ...    CREATE USER "dEmO" ACTIVE USING PLUGIN Srp;
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}


*** Keywords ***
Check User
    [Arguments]    ${type}
    Select From Tree Node Popup Menu    0    New Connection|Users (3)|${type}    Edit user
    Select Tab As Context    ${type}:Srp:USER:New Connection
    Select Tab    DDL to create
    ${res}=    Get Text Field Value    1
    RETURN    ${res}

Teardown
    Test Teardown
    Run Keyword And Ignore Error    Execute Immediate    DROP USER "DEMO"
    Run Keyword And Ignore Error    Execute Immediate    DROP USER "dEmO"
