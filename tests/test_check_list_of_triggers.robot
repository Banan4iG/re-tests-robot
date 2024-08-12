*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Click On Tree Node    0    New Connection|Tables (10)|EMPLOYEE    2
    Select Tab As Context    Triggers
    Sleep    1s
    ${row1}=    Find Table Row    0    SAVE_SALARY_CHANGE    Trigger Name
    ${row2}=    Find Table Row    0    SET_EMP_NO    Trigger Name
    Should Not Be Equal As Integers    ${row1}    -1
    Should Not Be Equal As Integers    ${row2}    -1
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row1}     Trigger Name    2    BUTTON1_MASK
    Select Dialog    Edit Trigger