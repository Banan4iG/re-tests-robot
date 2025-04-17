*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '2.6'}}
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST AS BEGIN END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST    2
    Check SQL    OWNER    CREATE OR ALTER PROCEDURE TEST AUTHID OWNER AS BEGIN END;
    Check SQL    CALLER    CREATE OR ALTER PROCEDURE TEST AUTHID CALLER AS BEGIN END;

*** Keywords ***
Check SQL
    [Arguments]    ${type}    ${ddl}
    Select From Combo Box    authidCombo    ${type}
    ${new_ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    ${new_ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}