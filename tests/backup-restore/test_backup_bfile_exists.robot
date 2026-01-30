*** Settings ***
Library          RemoteSwingLibrary
Resource         ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_1
    ${bk_path}=    Init
    Push Button    No

    # delete files
    Remove File    ${bk_path}

test_2
    ${bk_path}=    Init
    Push Button    Yes
    @{dialogs}=    List Dialogs
    Get Pom File
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

    # delete files
    Remove File    ${bk_path}


*** Keywords ***
Init
    ${bk_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Open Connection
    Select From Main Menu    Database|Database Backup/Restore
    Select Tab    Database backup/restore
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
    Select Tab    Database backup/restore
    Push Button    backupButton
    Select Dialog    Confirmation
    Label Text Should Be    0    The selected file exists.
    Label Text Should Be    1    Overwrite existing file?
    RETURN    ${bk_path}
