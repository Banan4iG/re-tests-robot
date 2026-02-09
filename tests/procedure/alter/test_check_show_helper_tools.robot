*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Open Connection
    Click On Tree Node    0    New Connection|Procedures (10)|DELETE_EMPLOYEE    2
    Select Tab As Context    DELETE_EMPLOYEE:PROCEDURE:New Connection
    Uncheck Check Box    showHelpersCheck
    Run Keyword And Expect Error
    ...    Can't select tab: Variables because it doesn't contain any container.
    ...    Select Tab As Context
    ...    Variables
    Check Check Box    showHelpersCheck

test_2
    Open Connection
    Click On Tree Node    0    New Connection|Procedures (10)|DELETE_EMPLOYEE    2
    Select Tab As Context    DELETE_EMPLOYEE:PROCEDURE:New Connection
    Push Button    2
    Run Keyword And Expect Error
    ...    Can't select tab: Variables because it doesn't contain any container.
    ...    Select Tab As Context
    ...    Variables
    Push Button    2

test_3
    Open Connection
    Click On Tree Node    0    New Connection|Procedures (10)|DELETE_EMPLOYEE    2
    Push Button    3
    Sleep    2s
    Push Button    2
    Sleep    2s
