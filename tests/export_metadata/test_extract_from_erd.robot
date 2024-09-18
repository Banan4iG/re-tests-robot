*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_ignore
    Open connection
    Select From Main Menu    Tools|ER-diagram editor
    Push Button    updateFromDatabase
    Select Dialog    Generate ERD
    Push Button    selectAllButton
    Push Button    Generate
    Sleep    2s
    Select Main Window
    Push Button    generateScriptsButton
    Push Button    selectAllExtractPropertiesButton
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    SQL
    ${script}=    Get Text Field Value    0
    @{result}=    Check Ignore    ${script}
    Should Be Equal As Strings    ${result}    [1, 0, 0, 0, 0]
    
test_not_ignore
    Open connection
    Select From Main Menu    Tools|ER-diagram editor
    Push Button    updateFromDatabase
    Select Dialog    Generate ERD
    Push Button    selectAllButton
    Push Button    Generate
    Sleep    2s
    Select Main Window
    Push Button    generateScriptsButton
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    SQL
    ${script}=    Get Text Field Value    0
    @{result}=    Check Ignore    ${script}
    Should Be Equal As Strings    ${result}    [1, 1, 1, 1, 1]

*** Keywords ***
Check Ignore
    [Arguments]    ${script}
    @{result}    Create List    ${{$script.count("Creating Tables")}}    ${{$script.count("COMPUTED FIELDs defining")}}    ${{$script.count("PRIMARY KEYs defining")}}    ${{$script.count("FOREIGN KEYs defining")}}    ${{$script.count("UNIQUE KEYs defining")}}
    RETURN    @{result}