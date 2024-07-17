*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Select From Menu        Tools|User Manager
    Push Button             addUserButton
    Select Dialog           Create user               #id: dialog0
    Clear Text Field        nameField
    Type Into Text Field    nameField          test
    Type Into Text Field    passTextField      test
    Type Into Text Field    firstNameField      test
    Type Into Text Field    middleNameField    test
    Type Into Text Field    lastNameField      test
    Push Button      submitButton
    Select Dialog    dialog1
    Push Button      commitButton
    Sleep    1s
    Select Window    regexp=^Red.*
    ${cellValue}=    Get Table Cell Value    usersTable    1    0
    Should Be Equal  TEST    ${cellValue}
    Select Table Cell    usersTable    1    0
    Push Button    deleteUserButton
    Select Dialog    Dropping object
    Push Button      commitButton