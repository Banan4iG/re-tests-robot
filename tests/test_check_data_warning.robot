*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Lock Employee
    Execute Immediate    CREATE TABLE NEW_TABLE_1(TEST_COL int)
    Open Connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2
    Select Tab As Context    NEW_TABLE_1:TABLE:New Connection
    Select Tab    Data
    Sleep    2s
    Push Button    0
    Sleep    1s
    Push Button    2
    Sleep    1s
    Click On Table Cell    0    0    TEST_COL
    Push Button    1
    Select Main Window
    Select Tab As Context    NEW_TABLE_1:TABLE:New Connection
    Run Keyword In Separate Thread    Select Tab    Constraints    ${EMPTY}
    Select Dialog    Confirmation
    Push Button    Yes
