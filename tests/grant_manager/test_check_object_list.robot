*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Skip
    # Lock Employee
    # Execute Immediate    CREATE GLOBAL TEMPORARY TABLE NEW_TABLE (TETS BIGINT) ON COMMIT DELETE ROWS
    # Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
    # Execute Immediate    CREATE PACKAGE NEW_PACK AS BEGIN END
    # Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    # Open connection
    # Select From Menu        Tools|Grant Manager
    # Sleep    1s
    # Push Button    refreshButton
    # @{column_values}=    Get Table Column Values    0    Object
    # Log Variables
    # @{expected_column_values}=    Create List    COUNTRY    CUSTOMER    DEPARTMENT    EMPLOYEE    EMPLOYEE_PROJECT    JOB    PROJECT    PROJ_DEPT_BUDGET    SALARY_HISTORY    SALES    NEW_TABLE    PHONE_LIST    ADD_EMP_PROJ    ALL_LANGS    DELETE_EMPLOYEE    DEPT_BUDGET    GET_EMP_PROJ    MAIL_LABEL    ORG_CHART    SHIP_ORDER    SHOW_LANGS    SUB_TOT_BUDGET    NEW_FUNC    NEW_PACK    CUST_NO_GEN    EMP_NO_GEN    CUSTOMER_CHECK    CUSTOMER_ON_HOLD    ORDER_ALREADY_SHIPPED    REASSIGN_SALES    UNKNOWN_EMP_ID
    # Should Be Equal As Strings    ${column_values}    ${expected_column_values}
    # Select From Combo Box    2    Tables
    # Uncheck Check Box    Tables    #not working