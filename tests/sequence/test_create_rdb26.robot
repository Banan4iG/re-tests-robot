*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource
Resource            keys.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver != '2.6'}}
    Lock Employee
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection|Sequences (2)    Create sequence
    Select Dialog    Create sequence
    Clear Text Field    nameField
    VAR    ${name}=    TEST_SEQUENCE
    Type Into Text Field    nameField    ${name}

    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${row_create}=    Find Table Row    0    CREATE SEQUENCE    Name operation
    ${row_alter}=    Find Table Row    0    ALTER SEQUENCE    Name operation

    Click On Table Cell    0    ${row_create}    Name operation
    ${res_create}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res_create}    CREATE SEQUENCE TEST_SEQUENCE

    Click On Table Cell    0    ${row_alter}    Name operation
    ${res_alter}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res_alter}    ALTER SEQUENCE TEST_SEQUENCE RESTART WITH 1

    Push Button    commitButton
    Sleep    0.1s
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create sequence'
    ...    Select Dialog
    ...    Create sequence

    Select Main Window
    Tree Node Should Exist    0    New Connection|Sequences (3)|${name}
