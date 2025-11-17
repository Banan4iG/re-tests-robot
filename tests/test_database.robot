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
    Label Text Should Be    0    Are you sure you want to delete the database
    # Label Text Should Be    1    "localhost:3050:${db_path}"?
    Push Button    Yes
    Sleep    1s
    File Should Not Exist    ${db_path}
    Select Main Window

test_recreate
    Create DB
    Select From Tree Node Popup Menu In Separate Thread    0    New Database    Recreate Database
    Select Dialog    Confirmation
    # Label Text Should Be    0    Database "localhost:3050:${db_path}"
    # Label Text Should Be    1    will be dropped and create again. Continue?
    Push Button    Yes
    Sleep    1s
    File Should Not Exist    ${db_path}

    Select Dialog    Message

    Label Text Should Be    0    The database will be created with the following parameters:
    Label Text Should Be    1    Server:
    Label Text Should Be    2    localhost
    Label Text Should Be    3    Port:
    Label Text Should Be    4    3050
    Label Text Should Be    5    Database path:
    # Label Text Should Be    6    ${db_path}
    Label Text Should Be    7    Charset:
    Label Text Should Be    8    NONE
    Label Text Should Be    9    Page size:
    Label Text Should Be    10    8192
    Label Text Should Be    11    User:
    Label Text Should Be    12    SYSDBA


    Push Button    OK
    Sleep    1s
    File Should Exist    ${db_path}

*** Keywords ***
Teardown
    Remove File    ${db_path}
    Teardown after every tests

Create DB
    # create
    Push Button    create-database-command
    Type Into Text Field    nameField    New Database
    Set Test Variable    ${db_path}    ${TEMPDIR}${/}test_database.fdb
    Remove File    ${db_path}
    Type Into Text Field    fileField    ${db_path}
    Type Into Text Field    userField    SYSDBA
    Type Into Text Field    passwordField    masterkey
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        Select From Combo Box    serverCombo    Red Database (Firebird) 2.X
        Select From Combo Box    authCombo    Basic
    END
    Push Button    createButton
    Select Dialog    Database Registration
    Push Button    Yes
    Select Main Window
    Tree Node Should Exist    0    New Database
    File Should Exist    ${db_path}