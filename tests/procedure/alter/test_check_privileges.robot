*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Click On Tree Node   0    New Connection|Procedures (10)|SHOW_LANGS    2
    Select Tab As Context    Privileges
    Sleep    1s
    Select Tab As Context    User → Objects
    Sleep    1s
    @{values}=    Get Table Column Values    0    Object
    Should Be Equal As Strings    ${values}    ['COUNTRY', 'CUSTOMER', 'DEPARTMENT', 'EMPLOYEE', 'EMPLOYEE_PROJECT', 'JOB', 'PROJECT', 'PROJ_DEPT_BUDGET', 'SALARY_HISTORY', 'SALES', 'PHONE_LIST', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET', 'CUST_NO_GEN', 'EMP_NO_GEN', 'CUSTOMER_CHECK', 'CUSTOMER_ON_HOLD', 'ORDER_ALREADY_SHIPPED', 'REASSIGN_SALES', 'UNKNOWN_EMP_ID']
    Select Main Window
    Select Tab As Context    Privileges
    Sleep    1s
    Select Tab As Context    Object → Users
    Sleep    1s
    @{values}=    Get Table Column Values    0    User
    Should Be Equal As Strings    ${values}    ['SYSDBA', 'PUBLIC', 'PHONE_LIST', 'POST_NEW_ORDER', 'SAVE_SALARY_CHANGE', 'SET_CUST_NO', 'SET_EMP_NO', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET']
    Select Main Window
    Select Tab As Context    Privileges
    Sleep    1s
    Select Tab As Context    DDL privileges
    Sleep    1s
    @{values}=    Get Table Column Values    0    Object
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    IF  ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        Should Be Equal As Strings    ${values}    ['DATABASE', 'TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'SEQUENCE', 'DOMAIN', 'EXCEPTION', 'ROLE', 'CHARACTER SET', 'COLLATION', 'FILTER', 'JOB', 'TABLESPACE']
    ELSE
        Should Be Equal As Strings    ${values}    ['DATABASE', 'TABLE', 'VIEW', 'PROCEDURE', 'FUNCTION', 'PACKAGE', 'SEQUENCE', 'DOMAIN', 'EXCEPTION', 'ROLE', 'CHARACTER SET', 'COLLATION', 'FILTER']
    END
