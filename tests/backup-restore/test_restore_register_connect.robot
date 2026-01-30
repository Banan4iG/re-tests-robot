*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown


*** Test Cases ***
test_1
    ${bk_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Open Connection
    Select From Main Menu    Database|Database Backup/Restore
    Uncheck All Checkboxes
    Clear Text Field    backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

    File Should Exist    ${bk_path}

    Select Main Window
    ${mew_db_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_restore.fdb
    Restore    ${mew_db_path}

    # check register
    Select Main Window
    Tree Node Should Exist    0    employee_restore

    Select From Main Menu    Database|Database Backup/Restore
    ${mew_db_path1}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_restore.fdb1
    Restore    ${mew_db_path1}
    Select Main Window
    Tree Node Should Exist    0    employee_restore (Copy)

    Select From Tree Node Popup Menu In Separate Thread    0    employee_restore    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Select Main Window
    Select From Tree Node Popup Menu In Separate Thread    0    employee_restore (Copy)    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes

    Remove Files    ${mew_db_path}    ${mew_db_path1}    ${bk_path}


*** Keywords ***
Restore
    [Arguments]    ${mew_db_path}
    Remove File    ${mew_db_path}
    Clear Text Field    databaseFileField
    Type Into Text Field    databaseFileField    ${mew_db_path}

    Select Tab As Context    Database backup/restore
    Select Tab    Restore
    Push Button    restoreButton
    Sleep    2s
    Select Dialog    Confirmation
    Label Text Should Be    0    Restore completed successfully!
    Label Text Should Be    1    Register restored database?
    Push Button    Yes
