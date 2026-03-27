*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Init
Test Teardown       Local Teardown


*** Test Cases ***
test_extract
    Push Button    extract-metadata-command
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    extractButton
    Select Dialog    Warning
    Label Text Should Be    0    Unable to compare.
    Label Text Should Be    1    Connection is inactive.

test_compare
    Click On Tree Node    0    New Connection
    Push Button    comparerDB-command
    Push Button    selectAllAttributesButton
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    compareButton
    Select Dialog    Warning
    Label Text Should Be    0    Unable to compare.
    Label Text Should Be    1    At least one of the connections is inactive.


*** Keywords ***
Init
    Test Setup
    Push Button    new-connection-command
    Type Into Combobox    hostCombo    ${EMPTY}
    Clear Text Field    portField
    Type Into Text Field    fileField    employee.fdb
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Push Button    saveButton

Local Teardown
    Close Dialog    Warning
    Select Main Window
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection 1    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Test Teardown
