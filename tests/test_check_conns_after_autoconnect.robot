*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown


*** Test Cases ***
test_1
    Skip If Embedded
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Open Connection
    Select From Menu    Tools|User Manager
    Select From Combo Box    databasesCombo    New Connection (Copy)
    Tree Node Should Not Be Leaf        0    New Connection (Copy)

    Click On Tree Node    0    New Connection (Copy)    2
    Select Main Window
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection (Copy)    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
