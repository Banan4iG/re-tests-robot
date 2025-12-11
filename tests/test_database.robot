*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown

*** Variables ***
${db_path}

*** Test Cases ***
test_create_drop
    Create DB
    # drop
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Drop Database
    Select Dialog    Confirmation
    ${label_content}=    Get Label Content    0
    Should Contain    ${label_content}    Are you sure you want to drop database
    # Label Text Should Be    0    Are you sure you want to drop database
    # Label Text Should Be    1    "localhost:3050:${db_path}"?
    Push Button    Yes
    Sleep    1s
    File Should Not Exist    ${db_path}
    Select Main Window

test_recreate
    Create DB
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Recreate Database
    Select Dialog    Confirmation
    ${label_content}=    Get Label Content    0
    Should Contain    ${label_content}    Are you sure you want to recreate database
    # Label Text Should Be    0    Are you sure you want to recreate database
    # Label Text Should Be    1    "localhost:3050:${db_path}"?
    Push Button    Yes
    Sleep    1s
    File Should Exist    ${db_path}

*** Keywords ***
Teardown
    Remove File    ${db_path}
    Teardown after every tests

Create DB
    # create
    Push Button    create-database-command
    Select Dialog    Create Database
    Set Test Variable    ${db_path}    ${TEMPDIR}${/}test_database.fdb
    Remove File    ${db_path}
    Type Into Combobox    hostCombo    localhost
    Type Into Text Field    portField    3050
    Type Into Text Field    pathField    ${db_path}
    Type Into Text Field    userField    SYSDBA
    Type Into Text Field    passwordField    masterkey
    Check Check Box    registerCheck
    List Components In Context
    Type Into Text Field    connectionName    New Database
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}
        Check Check Box    embeddedCheck
    END
    Push Button    createButton
    Select Main Window
    Tree Node Should Exist    0    New Database
    File Should Exist    ${db_path}
    
    Click On Tree Node    0    New Database    2
    Expand All Tree Nodes    0
    Tree Node Should Not Be Leaf    0    New Database