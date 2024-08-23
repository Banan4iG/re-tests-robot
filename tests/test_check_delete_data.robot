*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Lock Employee
    Execute Immediate    CREATE TABLE NEW_TABLE_1(TEST_COL VARCHAR(10))
    Execute Immediate    INSERT INTO NEW_TABLE_1 VALUES('PUBLIC')
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2   
    Select Tab As Context    Data
    Sleep    2s
    ${row}=    Find Table Row    0    PUBLIC    TEST_COL
    Click On Table Cell    0    ${row}    TEST_COL
    Push Button    1
    Push Button    2
    Sleep    2s
    ${row}=    Find Table Row    0    PUBLIC    TEST_COL
    ${result}=    Execute    SELECT * from NEW_TABLE_1
    Should Be Equal As Integers    ${row}    -1
    Should Be Equal    ${result}    []