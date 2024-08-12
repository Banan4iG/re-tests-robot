*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Push Button    extract-metadata-command
    Select Tab As Context    SQL    
    Push Button    saveScriptButton
    Select Dialog    Warning
    Push Button    OK
    Select Window    regexp=^Red.*
    Select Tab As Context    SQL
    Push Button    executeScriptButton
    Select Dialog    Warning
    Push Button    OK