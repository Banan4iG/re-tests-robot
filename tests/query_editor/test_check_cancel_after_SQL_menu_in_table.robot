*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Action    SELECT

test_2
    Action    INSERT

test_3
    Action    UPDATE

test_4
    Action    CREATE


*** Keywords ***
Action
    [Arguments]    ${type}
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection|Tables (10)|EMPLOYEE    Generate SQL|${type} statement
    Send Keyboard Event    VK_Z    CTRL_MASK
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    second=${EMPTY}
