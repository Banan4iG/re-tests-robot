*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Skip If Embedded
    Open Connection
    Check Text Tooltip    Disconnect
    Open Connection
    Check Text Tooltip    Connect


*** Keywords ***
Check Text Tooltip
    [Arguments]    ${expected}
    ${tooltip}=    Get Tooltip Text    connect-to-database-command
    Should Be Equal    ${expected}    ${tooltip}
