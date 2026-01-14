*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    action    SELECT

test_2
    action    INSERT

test_3
    action    UPDATE

test_4
    action    CREATE


*** Keywords ***
action
    [Arguments]    ${type}
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection|Tables (10)|EMPLOYEE    Generate SQL|${type} statement
    Send Keyboard Event    VK_Z    CTRL_MASK
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    second=
