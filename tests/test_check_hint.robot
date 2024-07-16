*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

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
