*** Settings ***
Library             Collections
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Select From Main Menu    System|Drivers
    Sleep    1s
    ${tableValues}=    Get Table Values    driversTable
    Sort List    ${tableValues}
    Should Be Equal As Strings
    ...    ${tableValues}
    ...    [['RedDatabase JDBC Driver 5', 'Latest RedDatabase JDBC Driver 5 (Recommended)', 'Red Database', 'org.firebirdsql.jdbc.FBDriver'], ['RedDatabase JDBC Driver 6', 'Latest RedDatabase JDBC Driver 6', 'Red Database', 'org.firebirdsql.jdbc.FBDriver']]
