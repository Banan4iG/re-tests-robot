*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
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