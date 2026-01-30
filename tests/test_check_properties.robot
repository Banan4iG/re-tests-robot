*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Click On Tree Node    0    New Connection    1
    Select From Table Cell Popup Menu    0    0    0    Properties
    Button Should Exist    Connect

    Select Main Window
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection (Copy)    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
