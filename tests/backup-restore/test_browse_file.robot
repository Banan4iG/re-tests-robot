*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_empty_file
    Init

    Push Button    backupButton
    Select Dialog    Warning
    Label Text Should Be    0    The file name must not be empty
    Push Button    OK

    Select Main Window
    Select Tab As Context    Database backup/restore
    Select Tab As Context    Restore
    Clear Text Field    backupFileField

    Push Button    restoreButton
    Select Dialog    Warning
    Label Text Should Be    0    The file name must not be empty
    Push Button    OK

test_browse_withot_fbk
    ${bk_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_backup
    Init

    Push Button    browseBackupFileButton
    Sleep    2s
    Select Dialog    Select Backup File
    Clear Text Field    0
    Type Into Text Field    0    ${bk_path}
    Push Button    Select

    Select Main Window
    ${bk_path_from_text_field}=    Get Text Field Value    backupFileField
    Should Not Be Equal As Integers    ${{$bk_path_from_text_field.find('.fbk')}}    -1

    Select Tab As Context    Database backup/restore
    Select Tab As Context    Restore
    Clear Text Field    backupFileField
    Push Button    browseBackupFileButton
    Sleep    2s
    Select Dialog    Select Backup File
    Clear Text Field    0
    Type Into Text Field    0    ${bk_path}
    Push Button    Select
    Select Main Window
    Select Tab As Context    Database backup/restore
    Select Tab As Context    Restore
    ${bk_path_from_text_field}=    Get Text Field Value    backupFileField
    Should Not Be Equal As Integers    ${{$bk_path_from_text_field.find('.fbk')}}    -1

test_not_fbk
    ${bk_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_backup.fb
    Init

    Type Into Text Field    backupFileField    ${bk_path}
    Push Button    backupButton
    Select Dialog    Warning
    Label Text Should Be    0    The file must have the .fbk extension
    Push Button    OK
    Select Main Window
    Select Tab As Context    Database backup/restore
    Select Tab As Context    Restore
    Clear Text Field    backupFileField
    Type Into Text Field    backupFileField    ${bk_path}
    Push Button    restoreButton
    Select Dialog    Warning
    Label Text Should Be    0    The file must have the .fbk extension
    Push Button    OK


*** Keywords ***
Init
    Open Connection
    Select From Main Menu    Database|Database Backup/Restore
    Clear Text Field    backupFileField
