*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Open Connection
    Click On Tree Node    0    New Connection|Tables (10)|EMPLOYEE    2
    Sleep    1s
    Select From Main Menu    System|Drivers
    Push Button    editor-command
    Push Button    editor-command
    Push Button    editor-command

    Close All Tabs
