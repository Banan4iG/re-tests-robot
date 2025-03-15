*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    OperatingSystem
Resource    ../../files/keywords.resource
Test Setup    Setup
Test Teardown    Teardown

*** Test Cases ***
test_no_reload
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Display
    ${row}=    Find Table Row    0    Interface language    1   
    Click On Table Cell    0    ${row}    2
    Run Keyword And Ignore Error    Select From Combo Box    0    Russian
    Push Button    applyButton
    Select Dialog    Confirmation
    Push Button    No
    System Exit    0
    Sleep    5s
    Setup before every tests
    Select From Main Menu    Система|Настройки
    Select Dialog    Настройки

test_auto_reload
    Skip    No working yet


*** Keywords ***
Setup
    Backup User Properties
    Setup before every tests

Teardown
    Teardown after every tests
    Restore User Properties