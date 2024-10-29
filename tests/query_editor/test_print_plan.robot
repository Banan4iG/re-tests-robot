*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

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