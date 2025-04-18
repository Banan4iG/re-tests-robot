*** Settings ***
Library    RemoteSwingLibrary
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Local Test Teardown

*** Test Cases ***
test_check_default_active
    Create Index
    Check Box Should Be Enabled    2

test_check_order_fields
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5.0'}}    
    Create Index
    Select From Combo Box    1    3
    Push Button    5
    Click On List Item    1    0
    ${i}=     Set Variable    0
    FOR    ${i}     IN RANGE    5
        Push Button    10
    END
    ${list}=    Get List Values    1
    ${result}=    Create List    FIRST_NAME    LAST_NAME    PHONE_EXT    HIRE_DATE    JOB_CODE    EMP_NO    JOB_GRADE    JOB_COUNTRY    SALARY
    Lists Should Be Equal    ${list}    ${result}

*** Keywords ***
Create Index
    Open connection
    Expand Tree Node    0    New Connection    
    Select From Tree Node Popup Menu    0    New Connection|Indices (38)    Create index
    Select Dialog    Create index   

Local Test Teardown
    Select Dialog    Create index
    Push Button    cancelButton

    Select Dialog    Confirmation
    Push Button    Yes
    
    Select Main Window
    Test Teardown