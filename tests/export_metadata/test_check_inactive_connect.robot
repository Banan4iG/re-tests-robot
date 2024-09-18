*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests


*** Test Cases ***
test_extract
    Push Button    new-connection-command
    Push Button    extract-metadata-command
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    extractButton

test_compare
    Push Button    new-connection-command
    Push Button    comparerDB-command
    Push Button    selectAllAttributesButton
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    compareButton
    Check Labels

*** Keywords ***
Check Labels
    Select Dialog    Warning
    Run Keyword And Continue On Failure    Label Text Should Be    0    Unable to compare.
    Run Keyword And Continue On Failure    Label Text Should Be    1    At least one of the connections is inactive.