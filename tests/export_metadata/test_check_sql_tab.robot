*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_save_script
    Start
    Select Tab As Context    SQL
    Push Button    saveScriptButton
    ${script_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /script.sql
    ${test_base_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /test.fdb
    Remove Files    ${script_path}    ${test_base_path}
    Select Dialog    Save Script
    Type Into Text Field    0    ${script_path}
    Push Button    Save Script
    Sleep    2s
    Close Dialog    Message
    Select Main Window
    Close Connection
    Execute Immediate    ALTER TABLE COUNTRY ADD NEW_COLUMN BIGINT
    Create Database    ${script_path}    ${test_base_path}
    Create Connect    ${test_base_path}
    Compare DB
    # Delete Objects    ${rdb5}
    [Teardown]    Local Teardown

test_execute_script
    Start
    Select Tab As Context    SQL
    Push Button    executeScriptButton
    Sleep    1s
    Select Main Window
    Select Tab As Context    regexp=^Untitled.*
    Combo Box Should Be Enabled    connectionsCombo
    ${text}=    Get Text Field Value    0
    Should Not Be Equal As Strings    ${text}    ${EMPTY}
    Button Should Be Enabled    execute-script-command
    # Delete Objects    ${rdb5}


*** Keywords ***
Start
    Lock Employee
    Create Objects
    Close All Tabs
    Push Button    extract-metadata-command
    Select Tab As Context    DB Metadata Export
    Push Button    extractButton
    Close Dialog    Message

Create Connect
    [Arguments]    ${test_base_path}
    Select Main Window
    Push Button    new-connection-command
    Sleep    1s
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
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

Compare DB
    Select Main Window
    Click On Tree Node    0    New Connection
    Push Button    comparerDB-command
    Select From Combo Box    dbMasterComboBox    New Connection 1
    Push Button    selectAllAttributesButton
    Check Check Box    ignoreWhitespaces
    Push Button    compareButton
    Sleep    2s
    Select Dialog    Message
    Run Keyword And Continue On Failure    Label Text Should Be    1    Objects to create - 0
    Run Keyword And Continue On Failure    Label Text Should Be    3    Objects to drop - 0
    Run Keyword And Continue On Failure    Label Text Should Be    2    Objects to alter - 1
    Sleep    2s
    Close Dialog    Message

Local Teardown
    Select Main Window
    Select From Tree Node Popup Menu    0    New Connection 1    Disconnect
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection 1    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Test Teardown
