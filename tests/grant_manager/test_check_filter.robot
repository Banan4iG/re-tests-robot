*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Select From Menu        Tools|Grant Manager
    Sleep    1s
    Type Into Text Field    0    C
    Type Into Text Field    0    U
    Type Into Text Field    0    S
    Sleep    1s
    @{column_values}=    Get Table Column Values    0    Object
    @{expected_column_values}=    Create List    CUSTOMER    CUST_NO_GEN    CUSTOMER_CHECK  CUSTOMER_ON_HOLD
    Should Be Equal As Strings    ${column_values}    ${expected_column_values}
    Check Check Box    Invert Filter
    @{column_values}=    Get Table Column Values    0    Object
    @{expected_column_values}=    Create List    COUNTRY    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET    EMP_NO_GEN    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    UNKNOWN_EMP_ID
    Should Be Equal As Strings    ${column_values}    ${expected_column_values}