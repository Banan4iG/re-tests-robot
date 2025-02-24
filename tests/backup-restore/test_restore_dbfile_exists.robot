*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${bk_path}=    Init

    Push Button    restoreButton
    Close Dialog    Error message

    Remove File    ${bk_path}

test_2
    ${bk_path}=    Init
    
    Check Check Box    restoreOverrideCheck
    Push Button    restoreButton
    
    Select Dialog    Message
    Label Text Should Be    0    Restore completed successfully!
    Remove File    ${bk_path}


*** Keywords ***
Init
    ${bk_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Select From Main Menu    Database|Database Backup/Restore
    Clear Text Field     backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

    File Should Exist    ${bk_path}

    Select Main Window
    Select Tab    Restore
    Uncheck All Checkboxes
    RETURN    ${bk_path}