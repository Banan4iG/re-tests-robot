*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../files/keywords.resource

Suite Setup         Skip If Embedded
Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Create New Conn
    Select From Tree Node Popup Menu    0    New Connection 1    Connect
    Tree Node Should Not Be Leaf    0    New Connection 1

test_2
    Create New Conn
    Click On Tree Node    0    New Connection 1    2
    Tree Node Should Not Be Leaf    0    New Connection 1


*** Keywords ***
Create New Conn
    Push Button    new-connection-command
    Sleep    1s
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        Select From Combo Box    serverCombo    Red Database (Firebird) 2.X
        Select From Combo Box    authCombo    Basic
    END
    Type Into Combobox    hostCombo    localhost
    Type Into Text Field    portField    3050
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}
        ${info}=    Get Server Info
        ${home_dir}=    Set Variable    ${info}[0]
        VAR    ${db_path}=    ${home_dir}examples/empbuild/employee.fdb
        Type Into Text Field    fileField    ${db_path}
    ELSE
        Type Into Text Field    fileField    employee.fdb
    END
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Check Check Box    Store Password
    List Components In Context
    IF    ${{$connect_type == 'embedded'}}
        Check Check Box    useEmbeddedCheck
    END
    Push Button    saveButton
