*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_with_connect
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    print-plan-command

test_no_connected
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY;
    Push Button    print-plan-command