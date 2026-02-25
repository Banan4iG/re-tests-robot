*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup
Test Teardown       Teardown


*** Test Cases ***
test_1
    [Timeout]    120s
    [Setup]    Setup
    Open Connection
    Sleep    1s
    Execute Script
    Sleep    3s

    Select Dialog    Result Set Limit Reached
    Check Limit    10,000
    Push Button    OK

    Select Main Window
    Execute Script
    Sleep    3s

    Select Dialog    Result Set Limit Reached
    Push Button    Increase limit

    Select Dialog    Preferences
    ${row}=    Find Table Row    0    Maximum records returned

    Clear Table Cell    0    ${row}    2
    Type Into Table Cell    0    ${row}    2    100000
    Click On Tree Node    0    Result Set Table
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences

    Select Dialog    Result Set Limit Reached
    Check Limit    100,000
    Push Button    Ignore limit
    Select Main Window
    Sleep    3s

    Click On Tree Node    0    New Connection|Tables (11)|TEST_TABLE    2
    Select Tab As Context    TEST_TABLE:TABLE:New Connection
    Select Tab As Context    Data
    Sleep    2s
    Push Button    Fetch all
    Sleep    3s
    Select Dialog    Result Set Limit Reached
    Check Check Box    blockDialogCheck
    Push Button    OK

    Select Main Window
    Select Tab As Context    TEST_TABLE:TABLE:New Connection
    Select Tab As Context    Data
    Push Button    5
    Push Button    Fetch all
    Sleep    3s
    Dialog Should Not Be Open    Result Set Limit Reached

    ${current_row_count}=    Get Table Row Count    0
    Should Be Equal As Integers    ${current_row_count}    100000


*** Keywords ***
Setup
    TRY
        System Exit    0
    EXCEPT
        Log    App is not run
    END
    Backup User Properties
    Test Setup

Teardown
    Select Main Window
    Close All Dialogs
    Close All Tabs
    Close Connection
    Unlock Employee
    System Exit    0
    Kill Rdbexpert
    Clear History Files
    Restore Savedconnections File
    Restore User Properties

Check Limit
    [Arguments]    ${limit}
    List Components In Context
    ${content}=    Get Label Content    1
    Should Contain    ${content}    limit [${limit}]

Execute Script
    Close All Tabs
    Push Button    editor-command
    Select Tab As Context    regexp=^Query Editor.*
    Clear Text Field    0
    Type Into Text Field    0    select * from test_table
    Push Button    execute-script-command
