*** Settings ***
Library    RemoteSwingLibrary
Library    Collections
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_1
    Sleep    1s
    ${tableValues}=    Get Table Values    driversTable
    Sort List    ${tableValues}
    Should Be Equal As Strings    ${tableValues}    [['Jaybird 3 Driver', 'Jaybird 3 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver'], ['Jaybird 4 Driver', 'Jaybird 4 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver'], ['Jaybird 5 Driver', 'Jaybird 5 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver']]
