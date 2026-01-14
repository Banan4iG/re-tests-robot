*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_with_connect
    Open Connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    print-plan-command

test_no_connected
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    print-plan-command
