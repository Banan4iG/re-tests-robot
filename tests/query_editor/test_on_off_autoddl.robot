*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


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
