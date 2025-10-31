*** Settings ***
Library    RemoteSwingLibrary
Library    Collections
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Main Menu    System|Drivers
    Sleep    1s
    ${tableValues}=    Get Table Values    driversTable
    Sort List    ${tableValues}
    Should Be Equal As Strings    ${tableValues}    [['Jaybird 6 Driver', 'Latest Jaybird 6 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver']]
