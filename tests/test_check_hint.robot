*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_1
    Open connection
    Check text tooltip    Disconnect
    Open connection
    Check text tooltip    Connect

*** Keywords ***
Check text tooltip
    [Arguments]    ${expected}
    ${tooltip}=    Get Tooltip Text    connect-to-database-command
    Should Be Equal    ${expected}    ${tooltip}
