*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Skip If Embedded
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Open Connection
    Select From Menu    Tools|User Manager
    Select From Combo Box    databasesCombo    New Connection (Copy)
    Tree Node Should Not Be Leaf    0    New Connection (Copy)
