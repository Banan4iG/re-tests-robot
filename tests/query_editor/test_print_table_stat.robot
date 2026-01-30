*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_sql_script
    Run Script    execute-script-command

test_single_statement
    Check Tool
    Run Script    execute-statement-command
    [Teardown]    Teardown


*** Keywords ***
Teardown
    Check Tool
    Teardown After Every Tests

Check Tool
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Tool Bar|Query Editor Tools
    ${values}=    Get Table Values    0
    ${row}=    Find Table Row    0    Execute single statement    2
    Click On Table Cell    0    ${row}    0
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window

Run Script
    [Arguments]    ${button}
    Open Connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM EMPLOYEE;
    Push Button    ${button}
    Sleep    1s
