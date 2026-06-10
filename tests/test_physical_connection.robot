*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource
Test Setup          Test Setup
Test Teardown       Local Test Teardown


*** Test Cases ***
test_1
    Lock Employee
    Open Connection
    Close All Tabs
    Push Button    editor-command
    Select Tab As Context    regexp=^Untitled.*
    Clear Text Field    0
    Insert Into Text Field    0    execute block as begin while (1 = 1) do begin end end
    Push Button    execute-script-command

    Select Main Window
    Select From Tree Node Popup Menu    0    New Connection|Roles    Create role
    Select Dialog    Create role
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create role'
    ...    Select Dialog    Create role
    Select Main Window
    Tree Node Should Exist    0    New Connection|Roles (1)|NEW_ROLE_1

    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type != 'embedded'}}
        Select From Main Menu    Tools|User Manager
        Sleep    1s
        ${values}=    Get Table Cell Value    usersTable    0    User name
        Should Be Equal As Strings    ${values}    SYSDBA
        ${result}=    Execute    select count (*) from mon$attachments where mon$user = 'SYSDBA'
        Should Be Equal As Strings    ${result}    [(4,)]
    END


*** Keywords ***
Local Test Teardown
    Test Setup
    Select Tab As Context    regexp=^Untitled.*
    Push Button    stop-execution-command
    Select Main Window
