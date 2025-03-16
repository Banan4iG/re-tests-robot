*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${path}=    Setup
    File Should Exist    ${path}
    ${content}=    Get File    ${path}
    Should Be Equal As Strings    ${content}    localhost
    Remove File    ${path}

test_2
    ${path}=    Setup
    Type Into Combobox    hostCombo    localhost231
    Type Into Combobox    hostCombo    host
    Push Button    saveButton
    Type Into Combobox    hostCombo    127.0.0.1
    Push Button    saveButton
    ${content}=    Get File    ${path}
    Should Be Equal As Strings    ${content}    127.0.0.1\nhost\nlocalhost
    
test_3
    ${path}=    Get Hosts History File
    File Should Exist    ${path}
    Setup before every tests
    Select From Tree Node Popup Menu    0    New Connection    New Connection
    Sleep   2s
    ${selected}=    Get Selected Item From Combo Box    hostCombo
    Should Be Equal As Strings    ${selected}    localhost
    @{value}=    Get Combobox Values    hostCombo
    Should Be Equal As Strings    ${value}    ['127.0.0.1', 'host', 'localhost']
    Select From Combo Box    hostCombo    127.0.0.1
    ${selected}=    Get Selected Item From Combo Box    hostCombo
    Should Be Equal As Strings    ${selected}    127.0.0.1
    Remove File    ${path}

*** Keywords ***
Setup
    ${path}=    Get Hosts History File
    Remove File    ${path}
    Setup before every tests
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Sleep   2s
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Connection information
    Sleep   2s
    RETURN    ${path}
