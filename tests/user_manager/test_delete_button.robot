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
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver != '2.6'}}
        Select Dialog    dialog1
        Push Button      commitButton
    END
    Sleep    1s
    Select Window    regexp=^Red.*
    ${row}=    Find Table Row    usersTable    TEST    User name
    ${cellValue}=    Get Table Cell Value    usersTable    ${row}    User name
    Should Be Equal  TEST    ${cellValue}
    Select Table Cell    usersTable    ${row}    User name
    Push Button    deleteUserButton
    IF    ${{$ver != '2.6'}}
        Select Dialog    Dropping object
        Push Button      commitButton
    END