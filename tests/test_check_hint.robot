*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Skip If Embedded
    Open Connection
    Check text tooltip    Disconnect
    Open Connection
    Check text tooltip    Connect


*** Keywords ***
Check text tooltip
    [Arguments]    ${expected}
    ${tooltip}=    Get Tooltip Text    connect-to-database-command
    Should Be Equal    ${expected}    ${tooltip}
