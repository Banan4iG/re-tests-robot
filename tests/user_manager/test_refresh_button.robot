*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Teardown


*** Test Cases ***
test_1
    Open Connection
    Select From Menu    Tools|User Manager
    Sleep    2s
    Execute Immediate    CREATE USER TEST_REFRESH_USER PASSWORD 'pass'
    ${rowCount}=    Get Table Row Count    usersTable
    Should Be Equal As Integers    1    ${rowCount}
    Push Button    refreshButton
    Sleep    2s
    ${rowCount}=    Get Table Row Count    usersTable
    Should Be Equal As Integers    2    ${rowCount}


*** Keywords ***
Teardown
    Test Teardown
    Run Keyword And Ignore Error    Execute Immediate    DROP USER TEST_REFRESH_USER
