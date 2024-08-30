*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Select From Main Menu    System|Drivers
    ${row}=    Find Table Row    0    Jaybird 4 Driver    Driver Name
    Run Keyword In Separate Thread    Click On Table Cell    0     ${row}    Driver Name    2    BUTTON1_MASK
    Select Dialog    Edit Driver
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${name}    Jaybird 4 Driver
    ${desc}=    Get Text Field Value    descField
    Should Be Equal As Strings    ${desc}    Jaybird 4 Driver
    ${dbname}=    Get Selected Item From Combo Box    databaseNameCombo
    Should Be Equal As Strings    ${dbname}    Red Database
    ${url}=    Get Selected Item From Combo Box   driverUrlCombo
    Should Be Equal As Strings    ${url}    jdbc:firebirdsql://[host]:[port]/[source]
    ${paths_list}=    Get List Values    0
    Should Be Equal As Strings    ${paths_list}    ['./lib/jaybird-4.jar', './lib/jaybird-cryptoapi-4.jar', './lib/fbclient-4.jar', '../lib/jaybird-4.jar', '../lib/jaybird-cryptoapi-4.jar', '../lib/fbclient-4.jar']
    ${classes}=    Get Selected Item From Combo Box   classField
    Should Be Equal As Strings    ${classes}    org.firebirdsql.jdbc.FBDriver