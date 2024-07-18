*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_create_table
    Open connection
    Expand Tree Node    0    New Connection    
    Select From Tree Node Popup Menu    0    New Connection|Tables (10)    Create table
    Create Table    CREATE TABLE "TEST TABLE" ( TEST BIGINT)

test_create_gtt
    Open connection
    Expand Tree Node    0    New Connection    
    Select From Tree Node Popup Menu    0    New Connection|Global Temporary Tables (0)    Create global temporary table
    Create Table    CREATE GLOBAL TEMPORARY TABLE "TEST TABLE" ( TEST BIGINT) ON COMMIT DELETE ROWS


*** Keywords ***
Create Table
    [Arguments]    ${expected_str}
    Select Dialog    Create Table
    Clear Text Field    nameField
    Type Into Text Field    nameField    TEST TABLE
    Type Into Table Cell    0    0    Name    TEST
    Set Table Cell Value    0    0    Datatype    BIGINT
    Click On Table Cell    0    0    Name    2      
    Send Keyboard Event    VK_ENTER                
    Push Button    submitButton
    Select Dialog    dialog1
    ${textFieldValue}=    Get Textfield Value    0
    Should Be Equal   ${textFieldValue}     ${expected_str}    collapse_spaces=True