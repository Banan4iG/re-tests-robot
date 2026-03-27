*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Local Setup
Test Teardown       Local Teardown


*** Test Cases ***
test_open_users
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Open Connection
    Click On Tree Node    0    New Connection (Copy)    2

    Click On Tree Node    0    New Connection|Users (1)|SYSDBA    2
    Click On Tree Node    0    New Connection (Copy)|Users (1)|SYSDBA    2

    Select Tab As Context    SYSDBA:Srp:USER:New Connection
    ${item}=    Get Selected Item From Combo Box    connectionsCombo
    Should Be Equal As Strings    ${item}    New Connection

    Select Main Window
    Select Tab As Context    SYSDBA:Srp:USER:New Connection (Copy)
    ${item}=    Get Selected Item From Combo Box    connectionsCombo
    Should Be Equal As Strings    ${item}    New Connection (Copy)


*** Keywords ***
Local Setup
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip if    ${{$ver == '2.6'}}
    Test Setup

Local Teardown
    IF    '${TEST_STATUS}' != 'SKIP'
        Select Main Window
        Close All Tabs
        Select From Tree Node Popup Menu    0    New Connection (Copy)    Disconnect
        Select From Tree Node Popup Menu In Separate Thread    0    New Connection (Copy)    Delete connection
        Select Dialog    Delete connection
        Push Button    Yes
        Test Teardown
    END
