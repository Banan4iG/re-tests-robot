*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_check_cursor
    Check Skip
    Open Connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Tablespaces    Create tablespace
    Select Dialog    Create tablespace
    Type Into Text Field    1    test_file.ts
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${textFieldValue}=    Get Textfield Value    0
    Should Be Equal
    ...    ${textFieldValue}
    ...    CREATE TABLESPACE NEW_TABLESPACE_1 FILE 'test_file.ts'
    ...    collapse_spaces=True


*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
