*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Local Test Teardown

*** Test Cases ***
test_check_cursor
    Check Skip
    Open connection
    Expand Tree Node    0    New Connection    
    Select From Tree Node Popup Menu    0    New Connection|Tablespaces (0)    Create tablespace
    Select Dialog    Create tablespace
    Type Into Text Field    1    test_file.ts
    Push Button    submitButton
    Select Dialog    dialog1
    ${textFieldValue}=    Get Textfield Value    0
    Should Be Equal   ${textFieldValue}     CREATE TABLESPACE NEW_TABLESPACE_1 FILE 'test_file.ts'    collapse_spaces=True

*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5.0' and $srv_ver == 'RedDatabase')}}

Local Test Teardown
    System Exit    0
    Clear History Files 