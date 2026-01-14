*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown


*** Test Cases ***
test_1
    Lock Employee
    Execute Immediate    CREATE TABLE NEW_TABLE_1(TEST_COL VARCHAR(10))
    Execute Immediate    INSERT INTO NEW_TABLE_1 VALUES('PUBLIC')
    Open Connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2
    Select Tab As Context    Data
    Sleep    2s
    ${row}=    Find Table Row    0    PUBLIC    TEST_COL
    Click On Table Cell    0    ${row}    TEST_COL
    Push Button    1
    Push Button    2
    Sleep    2s
    ${row}=    Find Table Row    0    PUBLIC    TEST_COL
    Should Be Equal As Integers    ${row}    -1


*** Keywords ***
Teardown
    System Exit    0
    ${result}=    Execute    SELECT * from NEW_TABLE_1
    Should Be Equal    ${result}    []
    Unlock Employee
    Clear History Files
    Restore Savedconnections File
