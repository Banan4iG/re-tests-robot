*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection    Extract Metadata
    Select Tab As Context    DB Metadata Export
    Select Tab As Context    SQL
    Push Button    saveScriptButton
    Select Dialog    Warning
    Push Button    OK

    Select Main Window
    Select Tab As Context    DB Metadata Export
    Select Tab As Context    SQL
    Push Button    executeScriptButton
    Select Dialog    Warning
    Push Button    OK

    Select Main Window
    Push Button    selectAllExtractAttributesButton
    Push Button    executeScriptButton
    Select Dialog    Warning
    Push Button    OK
