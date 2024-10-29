*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    select * from employee;\nselect * from employee;
    ${res}=    Get Text Field Value    0
    Send Keyboard Event    VK_A    CTRL_MASK
    Send Keyboard Event    VK_SLASH    CTRL_MASK
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    --select * from employee;\n--select * from employee;
    Send Keyboard Event    VK_Z   CTRL_MASK
    Send Keyboard Event    VK_Z   CTRL_MASK
    ${res}=    Get Text Field Value    0
    Send Keyboard Event    VK_A    CTRL_MASK
    Send Keyboard Event    VK_BACK_SPACE
    Send Keyboard Event    VK_S    CTRL_MASK
    Should Be Equal As Strings    ${res}    select * from employee;\nselect * from employee;