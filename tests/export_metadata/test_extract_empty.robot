*** Settings ***
Library             RemoteSwingLibrary
Library             firebird.driver
Library             fdb
Library             platform
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Local Teardown


*** Test Cases ***
test_extract
    ${test_base_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /test.fdb
    Remove File    ${test_base_path}
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    IF    $ver != '2.6'
        firebird.driver.Create Database    database=${test_base_path}    user=SYSDBA    password=masterkey
    ELSE
        VAR    ${home}=    ${info}[0]
        fdb.Load Api    ${home}bin/fbclient.dll
        fdb.Create Database    database=${test_base_path}    user=SYSDBA    password=masterkey
    END
    Select Main Window
    Push Button    new-connection-command
    Sleep    1s
    IF    ${{$ver == '2.6'}}
        Select From Combo Box    serverCombo    Red Database (Firebird) 2.X
        Select From Combo Box    authCombo    Basic
    END
    Type Into Combobox    hostCombo    localhost
    Type Into Text Field    portField    3050
    Type Into Text Field    fileField    ${test_base_path}
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Check Check Box    Store Password
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}
        Check Check Box    useEmbeddedCheck
    END
    Push Button    saveButton

    Push Button    extract-metadata-command
    Select From Combo Box    dbTargetComboBox    New Connection 1
    Push Button    extractButton
    Sleep    5s
    Select Dialog    Message
    Run Keyword And Continue On Failure    Label Text Should Be    1    Objects to create - 0
    Close Dialog    Message


*** Keywords ***
Local Teardown
    Select Main Window
    Select From Tree Node Popup Menu    0    New Connection 1    Disconnect
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection 1    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Test Teardown
