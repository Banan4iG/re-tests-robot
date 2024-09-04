*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_data_with_space
    Lock Employee
    Execute Immediate    CREATE TABLE NEW_TABLE_1 (\"TEST COL\" VARCHAR(50))
    Execute Immediate    INSERT INTO NEW_TABLE_1 (\"TEST COL\") VALUES (null)
    Open connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2   
    Select Tab As Context    Data
    Sleep    2s
    Select From Table Cell Popup Menu    0    0    TEST COL    Double-Click Opens Item View
    Type Into Table Cell    0    0    TEST COL    PUBLIC
    Send Keyboard Event    VK_ENTER
    Push Button    2
    Select From Table Cell Popup Menu    0    0    TEST COL    Double-Click Opens Item View
    ${res1}=    Execute    SELECT * FROM NEW_TABLE_1
    Click On Table Cell    0    0    TEST COL
    Push Button    1
    Push Button    2
    ${res2}=    Execute    SELECT * FROM NEW_TABLE_1
    Should Be Equal    ${res1}    [('PUBLIC',)]
    Should Be Equal    ${res2}    []