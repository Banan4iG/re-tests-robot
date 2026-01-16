*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Open Connection
    Click On Tree Node    0    New Connection|Tables (10)|EMPLOYEE    2
    Sleep    1s
    Push Button    editor-command

    Select Tab As Context    Query Editor - 1
    Sleep    5s
    Click On Component    iconClose

    Select Tab    EMPLOYEE:TABLE:New Connection
    Sleep    5s

    Sleep    5s

    Click On Component    iconClose
    Sleep    5s
