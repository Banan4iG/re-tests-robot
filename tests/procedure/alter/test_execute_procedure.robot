*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_exexute
    Init Procedure    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS BEGIN tot = 55; END

test_select
    Init Procedure
    ...    CREATE OR ALTER PROCEDURE TEST RETURNS ( TOT INTEGER ) AS BEGIN SELECT 55 FROM RDB$DATABASE INTO :TOT; SUSPEND; END


*** Keywords ***
Init Procedure
    [Arguments]    ${create_script}
    Lock Employee
    Execute Immediate    ${create_script}
    Open Connection
    Click On Tree Node    0    New Connection|Procedures (11)|TEST    2
    Push Button    actionButton
    Select Dialog    Execute Procedure
    @{value1}=    Get Table Values    0
    Should Be Equal As Strings    ${value1}    [['TOT', 'INTEGER(4)', 'OUT']]
    Push Button    executeButton
    @{value2}=    Get Table Values    1
    Should Be Equal As Strings    ${value2}    [['55']]
    Close Dialog    Execute Procedure
