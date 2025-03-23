*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Local Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_extract
    Push Button    extract-metadata-command
    Combo Box Should Be Disabled    dbTargetComboBox
    Push Button    extractButton
    Select Dialog    Warning
    Run Keyword And Continue On Failure    Label Text Should Be    0    Unable to compare.
    Run Keyword And Continue On Failure    Label Text Should Be    1    Connection is inactive.


test_compare
    Push Button    comparerDB-command
    Combo Box Should Be Disabled    dbMasterComboBox
    Combo Box Should Be Disabled    dbTargetComboBox
    Push Button    compareButton
    Select Dialog    Warning
    Run Keyword And Continue On Failure    Label Text Should Be    0    Unable to compare.
    Run Keyword And Continue On Failure    Label Text Should Be    1    The same connections selected.

*** Keywords ***
Local Setup
    Setup before every tests
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Select Main Window