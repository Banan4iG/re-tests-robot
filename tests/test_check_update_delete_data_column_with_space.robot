*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_data_with_space
    Lock Employee
    Execute Immediate    CREATE TABLE NEW_TABLE_1 (\"TEST COL\" VARCHAR(50))
    Execute Immediate    INSERT INTO NEW_TABLE_1 (\"TEST COL\") VALUES (null)
    Open Connection
    Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2
    Select Tab As Context    Data
    Sleep    2s
    Type Into Table Cell    0    0    TEST COL    PUBLIC
    Send Keyboard Event    VK_ENTER
    Push Button    2
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}
        Select Main Window
        Close Connection
    END
    ${res1}=    Execute    SELECT * FROM NEW_TABLE_1
    IF    ${{$connect_type == 'embedded'}}
        Select Main Window
        Open Connection
        Sleep    2s
        Click On Tree Node    0    New Connection|Tables (11)|NEW_TABLE_1    2
        Select Tab As Context    Data
        Sleep    2s
    END
    Click On Table Cell    0    0    TEST COL
    Push Button    1
    Push Button    2
    Sleep    2s
    IF    ${{$connect_type == 'embedded'}}
        Select Main Window
        Close Connection
    END
    ${res2}=    Execute    SELECT * FROM NEW_TABLE_1
    Should Be Equal    ${res1}    [('PUBLIC',)]
    Should Be Equal    ${res2}    []
