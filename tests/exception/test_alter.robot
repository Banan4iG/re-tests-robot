*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Init    NEW_EXP    NEW_EXP
    Select Tab As Context    Text
    Clear Text Field    0
    Type Into Text Field    0    new_message
    Select Main Window
    Check    CREATE OR ALTER EXCEPTION NEW_EXP 'new_message'

test_2
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Init    "NEW EXP"    NEW EXP
    Select Tab As Context    Privileges
    Sleep    1s
    # Check Box Should Be Enabled    Show System Objects
    @{values}=    Get Table Column Values    0    User
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}
        Should Be Equal As Strings
        ...    ${values}
        ...    ['PUBLIC', 'PHONE_LIST', 'POST_NEW_ORDER', 'SAVE_SALARY_CHANGE', 'SET_CUST_NO', 'SET_EMP_NO', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET']
    ELSE
        Should Be Equal As Strings
        ...    ${values}
        ...    ['SYSDBA', 'PUBLIC', 'PHONE_LIST', 'POST_NEW_ORDER', 'SAVE_SALARY_CHANGE', 'SET_CUST_NO', 'SET_EMP_NO', 'ADD_EMP_PROJ', 'ALL_LANGS', 'DELETE_EMPLOYEE', 'DEPT_BUDGET', 'GET_EMP_PROJ', 'MAIL_LABEL', 'ORG_CHART', 'SHIP_ORDER', 'SHOW_LANGS', 'SUB_TOT_BUDGET']
    END

test_3
    Init    """NEW EXP"""    "NEW EXP"
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings
    ...    ${res}
    ...    CREATE EXCEPTION """NEW EXP""" 'message';
    ...    strip_spaces=${True}
    ...    collapse_spaces=${True}

test_4
    Init    NEW_EXP    NEW_EXP
    Select Tab As Context    Dependencies
    Sleep    1s
    Expand All Tree Nodes    0
    @{tree1}=    Get Tree Node Child Names    0    New Connection
    @{tree2}=    Get Tree Node Child Names    1    New Connection
    @{tree_proc}=    Get Tree Node Child Names    0    New Connection|Procedures (1)
    Should Be Equal As Strings    ${tree_proc}    ['NEW_PROC']
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
        IF    ${{$connect_type == 'embedded'}}
            Should Be Equal As Strings
            ...    ${tree1}
            ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices', 'Tablespaces']
            Should Be Equal As Strings
            ...    ${tree2}
            ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices', 'Tablespaces']
        ELSE
            Should Be Equal As Strings
            ...    ${tree1}
            ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
            Should Be Equal As Strings
            ...    ${tree2}
            ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices', 'Tablespaces', 'Jobs']
        END
    ELSE IF    ${{$ver == '2.6'}}
        Should Be Equal As Strings
        ...    ${tree1}
        ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Table Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices']
        Should Be Equal As Strings
        ...    ${tree2}
        ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Table Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices']
    ELSE
        Should Be Equal As Strings
        ...    ${tree1}
        ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
        Should Be Equal As Strings
        ...    ${tree2}
        ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures', 'Functions', 'Packages', 'Table Triggers', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Users', 'Roles', 'Indices']
    END


*** Keywords ***
Init
    [Arguments]    ${create_name}    ${tree_name}
    Lock Employee
    Execute Immediate    CREATE OR ALTER EXCEPTION ${create_name} 'message'
    IF    '${TEST_NAME}' == 'test_4'
        Execute Immediate    CREATE OR ALTER PROCEDURE NEW_PROC AS BEGIN EXCEPTION ${create_name}; END;
    END

    Open Connection
    Click On Tree Node    0    New Connection|Exceptions (6)|${tree_name}    2
    Select Tab As Context    ${tree_name}:EXCEPTION:New Connection
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${tree_name}    ${name}

Check
    [Arguments]    ${text}
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}

    Push Button    commitButton
    Sleep    0.1s
    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Commiting changes'
    ...    Select Dialog
    ...    Commiting changes
