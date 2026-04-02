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
    Select Tab As Context    EMPLOYEE:TABLE:New Connection
    Select Tab As Context    Data
    Sleep    5s
    Select Main Window
    Click On Component    closeTabLabel for "EMPLOYEE:TABLE:New Connection"
    Check Close Tab    EMPLOYEE:TABLE:New Connection
    Select Tab As Context    Drivers
    Component Should Exist    addDriverButton
    Select Main Window
    Click On Component    closeTabLabel for "Drivers"
    Check Close Tab    Drivers

test_2
    Open Connection
    TRY
        Select Tab As Context    regexp=^Untitled.*
    EXCEPT    Can't select tab: regexp=^Untitled.* because it doesn't contain any container.
        Push Button    editor-command
        Select Tab As Context    regexp=^Untitled.*
    END
    Clear Text Field    0
    Type Into Text Field    0    select FIRST 1 * from COUNTRY
    Push Button    execute-script-command
    Sleep    1s

    Select Tab As Context    Result Set 1
    ${values}=    Get Table Values    0
    Should Be Equal As Strings    ${values}    [['USA', 'Dollar']]

    Select Main Window
    Select Tab As Context    regexp=^Untitled.*
    Click On Component    closeTabLabel for "Result Set 1"
    Click On Component    closeTabLabel for "Output"

    Check Close Tab    Result Set 1
    Check Close Tab    Output


*** Keywords ***
Check Close Tab
    [Arguments]    ${tab_name}
    Set Jemmy Timeouts    0
    TRY
        Select Tab As Context    ${tab_name}
    EXCEPT    Can't select tab: ${tab_name} because it doesn't contain any container.
        Log    Tab ${tab_name} closed
    END
    Set Jemmy Timeouts    5
