*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_1
    ${bk_path}=    Init

    Push Button    restoreButton
    Close Dialog    Error message
    
    Select Main Window
    Select Tab    Backup
    Remove File    ${bk_path}

test_2
    ${bk_path}=    Init

    Check Check Box    restoreOverrideCheck
    Push Button    restoreButton

    Select Dialog    Message
    Label Text Should Be    0    Restore completed successfully!
    Push Button    OK
    Select Main Window
    Select Tab    Backup
    Remove File    ${bk_path}

test_3
    ${bk_path}=    Init
    ${info}=    Get Server Info
    ${home_dir}=    Set Variable    ${info}[0]
    VAR    ${db_path}=    ${home_dir}examples/empbuild/employee.fdb
    Clear Text Field    databaseFileField
    Type Into Text Field    databaseFileField    ${db_path}
    Push Button    restoreButton
    Select Dialog    Confirmation
    Label Text Should Be    0    The selected file exists.
    Label Text Should Be    1    Overwrite existing file?
    Push Button    No
    Select Main Window
    Select Tab    Backup
    Remove File    ${bk_path}


*** Keywords ***
Init
    ${bk_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Select From Main Menu    Database|Database Backup/Restore
    Clear Text Field    backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

    File Should Exist    ${bk_path}

    Select Main Window
    Select Tab As Context    Database backup/restore
    Select Tab    Restore
    Uncheck All Checkboxes
    RETURN    ${bk_path}
