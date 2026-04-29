*** Settings ***
Library             OperatingSystem
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Teardown


*** Variables ***
${DB_PATH}      ${TEMPDIR}${/}test_database.fdb


*** Test Cases ***
test_create_drop
    Create DB
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Drop Database
    Select Dialog    Confirmation
    ${label_content}=    Get Label Content    1
    Should Contain    ${label_content}    Are you sure you want to drop database
    Sleep    6s
    Push Button    Yes
    Sleep    1s
    File Should Not Exist    ${DB_PATH}
    Select Main Window

test_recreate
    Create DB
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Recreate Database
    Select Dialog    Confirmation
    ${label_content}=    Get Label Content    1
    Should Contain    ${label_content}    Are you sure you want to recreate database
    Sleep    6s
    Push Button    Yes
    Sleep    1s
    File Should Exist    ${DB_PATH}

test_recreate_alias
    Add Alias To DBMS
    Create DB    alias=${True}
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Recreate Database
    Select Dialog    Confirmation
    ${label_content}=    Get Label Content    1
    Should Contain    ${label_content}    Are you sure you want to recreate database
    Sleep    6s
    Push Button    Yes
    Sleep    1s
    File Should Exist    ${DB_PATH}
    [Teardown]    Restore Databases Conf


*** Keywords ***
Teardown
    Select Main Window
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Remove File    ${DB_PATH}
    Test Teardown

Create DB
    # create
    [Arguments]    ${alias}=${False}
    Push Button    create-database-command
    Select Dialog    Create Database
    Remove File    ${DB_PATH}
    Type Into Combobox    hostCombo    localhost
    Type Into Text Field    portField    3050
    IF    ${alias}
        Type Into Text Field    pathField    test_database.fdb
    ELSE
        Type Into Text Field    pathField    ${DB_PATH}
    END
    Type Into Text Field    userField    SYSDBA
    Type Into Text Field    passwordField    masterkey
    Check Check Box    registerCheck
    List Components In Context
    Type Into Text Field    connectionName    New Database
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}    Check Check Box    embeddedCheck
    Push Button    createButton
    Select Main Window
    Tree Node Should Exist    0    New Database
    File Should Exist    ${DB_PATH}

    Click On Tree Node    0    New Database    2
    Expand All Tree Nodes    0
    Tree Node Should Not Be Leaf    0    New Database

    Select From Tree Node Popup Menu    0    New Database    Disconnect

Add Alias To DBMS
    ${info}=    Get Server Info
    VAR    ${home_dir}=    ${info}[0]
    VAR    ${databases_conf_path}=    ${home_dir}databases.conf
    VAR    ${databases_conf_path_bk}=   ${databases_conf_path}.bak
    Copy File    ${databases_conf_path}    ${databases_conf_path_bk}
    VAR    ${databases_conf_content}=    ${\n}test_database.fdb = ${DB_PATH}
    Append To File    ${databases_conf_path}    ${databases_conf_content}

Restore Databases Conf
    Teardown
    ${info}=    Get Server Info
    VAR    ${home_dir}=    ${info}[0]
    VAR    ${databases_conf_path}=    ${home_dir}databases.conf
    VAR    ${databases_conf_path_bk}=    ${databases_conf_path}.bak
    Copy File    ${databases_conf_path_bk}    ${databases_conf_path}
    Remove File    ${databases_conf_path_bk}
