*** Settings ***
Library             RemoteSwingLibrary
Library             Process
Library             Collections
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Open Connection
    Select From Menu    Tools|User Manager
    Push Button    addRoleButton
    Select Dialog    Create role
    Type Into Text Field    nameField    test_role
    Push Button    submitButton
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    Sleep    1s
    ${row}=    Find Table Row    rolesTable    TEST_ROLE    Role name
    ${result}=    Execute    select CAST(rdb$role_name as VARCHAR(10)) from rdb$roles where rdb$role_name='TEST_ROLE'
    Should Be Equal    ${result}    [('TEST_ROLE ',)]
    Click On Table Cell    rolesTable    ${row}    Role name
    Push Button    deleteRoleButton
    Select Dialog    Commiting changes
    Push Button    commitButton
