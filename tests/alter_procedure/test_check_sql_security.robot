*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Resource    keys.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE TEST AS BEGIN END
    Open connection
    Click On Tree Node   0    New Connection|Procedures (11)|TEST    2
    Check SQL    DEFINER    CREATE OR ALTER PROCEDURE TEST SQL SECURITY DEFINER AS BEGIN END;
    Check SQL    INVOKER    CREATE OR ALTER PROCEDURE TEST SQL SECURITY INVOKER AS BEGIN END;

*** Keywords ***
Check SQL
    [Arguments]    ${type}    ${ddl}
    Select From Combo Box    securityCombo    ${type}
    ${new_ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}
    Push Button    submitButton
    Select Dialog    Edit procedure
    Push Button    commitButton
    Select Main Window
    ${new_ddl}=    Get Text Field Value    1
    Should Be Equal As Strings    ${new_ddl}    ${ddl}    strip_spaces=${True}    collapse_spaces=${True}