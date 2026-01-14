*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Click On Tree Node    0    New Connection    1
    Select From Table Cell Popup Menu    0    0    0    Connection properties
    Button Should Exist    Connect
