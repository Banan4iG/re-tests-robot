*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Push Button    editor-command
    Clear Text Field    0
    Type Into Text Field    0    SET AUTODDL ON
    Push Button    execute-script-command
    Clear Text Field    0
    Type Into Text Field    0    SET AUTODDL OFF
    Push Button    execute-script-command
    Clear Text Field    0