*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Main Menu    System|Drivers
    ${tableValues}=    Get Table Values    0
    Should Be Equal As Strings    ${tableValues}    [['Jaybird 5 Driver', 'Jaybird 5 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver'], ['Jaybird 4 Driver', 'Jaybird 4 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver'], ['Jaybird 3 Driver', 'Jaybird 3 Driver', 'Red Database', 'org.firebirdsql.jdbc.FBDriver']]