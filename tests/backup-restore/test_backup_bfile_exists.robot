*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${bk_path}=    Init
    Push Button    No

    # delete files
    Remove Files    ${bk_path}

test_2
    ${bk_path}=    Init
    Push Button    Yes

    # Temporary handling of dialog Error message. See RS-201698    
    Close Dialog    Error message

    # delete files
    Remove Files    ${bk_path}


*** Keywords ***
Init
    ${bk_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_backup.fbk
    Select From Main Menu    Database|Database Backup/Restore
    Uncheck All Checkboxes
    Clear Text Field     backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK
    
    File Should Exist    ${bk_path}

    Select Main Window
    Push Button    backupButton
    Select Dialog    Confirmation
    Label Text Should Be    0    The selected file exists.
    Label Text Should Be    1    Overwrite existing file?
    RETURN    ${bk_path}
    