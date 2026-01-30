*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    Open Connection
    Select From Main Menu    Tools|Import Data
    Sleep    1s
    Select Tab As Context    Import Data
    @{values}=    Get Combobox Values    targetTableCombo
    Should Be Equal As Strings    ${values}    ['COUNTRY', 'CUSTOMER', 'DEPARTMENT', 'EMPLOYEE', 'EMPLOYEE_PROJECT', 'JOB', 'PROJECT', 'PROJ_DEPT_BUDGET', 'SALARY_HISTORY', 'SALES', 'PHONE_LIST']
    Type Into Combobox    targetTableCombo    EMPLOYEE
    @{values}=    Get Combobox Values    targetTableCombo
    Should Be Equal As Strings    ${values}    ['EMPLOYEE', 'EMPLOYEE_PROJECT']
