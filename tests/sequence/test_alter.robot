*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_1
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip if    ${{$ver == '2.6'}}
    Init    NEW_SEQ    NEW_SEQ
    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        Clear Text Field    startValueField
        Type Into Text Field    startValueField    100
    END

    Clear Text Field    currentValueField
    Type Into Text Field    currentValueField    90

    Clear Text Field    incrementField
    Type Into Text Field    incrementField    10

    Check    ${ver}    ${srv_ver}

    Select Main Window
    ${start_value}=    Get Text Field Value    startValueField
    ${increment}=    Get Text Field Value    incrementField
    ${current_value}=    Get Text Field Value    currentValueField
    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        VAR    ${expected_start_value}=    100
        Should Be Equal As Strings    ${start_value}    ${expected_start_value}
        Should Be Equal As Strings    ${current_value}    80
    ELSE
        VAR    ${expected_start_value}=    90
        Should Be Equal As Strings    ${start_value}    ${expected_start_value}
        Should Be Equal As Strings    ${current_value}    90
    END
    Should Be Equal As Strings    ${increment}    10

    Select Tab As Context    NEW_SEQ:SEQUENCE:New Connection
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings
    ...    ${res}
    ...    CREATE SEQUENCE NEW_SEQ START WITH ${expected_start_value} INCREMENT BY 10;
    ...    strip_spaces=${True}
    ...    collapse_spaces=${True}

test_2
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip if    ${{$ver == '2.6'}}
    Init    NEW_SEQ    NEW_SEQ
    ${start_value}=    Get Text Field Value    startValueField
    ${increment}=    Get Text Field Value    incrementField
    ${current_value}=    Get Text Field Value    currentValueField
    Should Be Equal As Strings    ${start_value}    10
    ${info}=    Get Server Info
    IF    ${{$ver == '5'}}
        Should Be Equal As Strings    ${current_value}    9
    ELSE
        Should Be Equal As Strings    ${current_value}    10
    END
    Should Be Equal As Strings    ${increment}    1

test_3
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip if    ${{$ver == '2.6'}}
    Init    "NEW SEQ"    NEW SEQ
    Select Tab As Context    Privileges
    Sleep    1s
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

test_4
    Init    NEW_SEQ    NEW_SEQ
    Select Tab As Context    Dependencies
    Sleep    1s
    Expand All Tree Nodes    0
    @{tree1}=    Get Tree Node Child Names    0    New Connection
    @{tree2}=    Get Tree Node Child Names    1    New Connection
    @{tree_proc}=    Get Tree Node Child Names    0    New Connection|Procedures (1)
    Should Be Equal As Strings    ${tree_proc}    ['NEW_PROC']
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
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

test_5
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Init    """NEW SEQ"""    "NEW SEQ"
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    IF    ${{$ver != '2.6'}}
        Should Be Equal As Strings
        ...    ${res}
        ...    CREATE SEQUENCE """NEW SEQ""" START WITH 10 INCREMENT BY 1;
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}
    ELSE
        Should Be Equal As Strings
        ...    ${res}
        ...    CREATE SEQUENCE """NEW SEQ"""; ALTER SEQUENCE """NEW SEQ""" RESTART WITH 0;
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}
    END

test_6
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip if    ${{$ver == '2.6'}}
    Init    NEW_SEQ    NEW_SEQ
    Push Button    Restart

    Single Check    ALTER SEQUENCE NEW_SEQ RESTART

test_restart_with_on_rdb26
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip if    ${{$ver != '2.6'}}
    Init    NEW_SEQ    NEW_SEQ

    Clear Text Field    currentValueField
    Type Into Text Field    currentValueField    90

    Push Button    submitButton

    Single Check    ALTER SEQUENCE NEW_SEQ RESTART WITH 90

    Select Main Window
    ${current_value}=    Get Text Field Value    currentValueField
    Should Be Equal As Strings    ${current_value}    90

    Select Tab As Context    NEW_SEQ:SEQUENCE:New Connection
    Select Tab As Context    DDL to create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings
    ...    ${res}
    ...    CREATE SEQUENCE NEW_SEQ; ALTER SEQUENCE NEW_SEQ RESTART WITH 90;
    ...    strip_spaces=${True}
    ...    collapse_spaces=${True}


*** Keywords ***
Init
    [Arguments]    ${create_name}    ${tree_name}
    Lock Employee
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        Execute Immediate    CREATE SEQUENCE ${create_name}
        VAR    ${create_proc}=
        ...    CREATE OR ALTER PROCEDURE NEW_PROC RETURNS ( NEW_GEN INTEGER ) AS BEGIN NEW_GEN = gen_id(NEW_SEQ, 1); END
    ELSE
        Execute Immediate    CREATE OR ALTER SEQUENCE ${create_name} START WITH 10 INCREMENT BY 1
        VAR    ${create_proc}=
        ...    CREATE OR ALTER PROCEDURE NEW_PROC RETURNS ( NEW_GEN INTEGER ) AS BEGIN :NEW_GEN = gen_id(NEW_SEQ, 1); END
    END
    IF    '${TEST_NAME}' == 'test_4'    Execute Immediate    ${create_proc}
    Open Connection
    Click On Tree Node    0    New Connection|Sequences (3)|${tree_name}    2
    Select Tab As Context    ${tree_name}:SEQUENCE:New Connection
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${tree_name}    ${name}

Check
    [Arguments]    ${ver}    ${srv_ver}
    Push Button    submitButton
    Select Dialog    Commiting changes

    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        Click On Table Cell    0    0    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings
        ...    ${res}
        ...    ALTER SEQUENCE NEW_SEQ START WITH 100
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}

        Click On Table Cell    0    1    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings
        ...    ${res}
        ...    ALTER SEQUENCE NEW_SEQ INCREMENT BY 10
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}

        Click On Table Cell    0    2    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings
        ...    ${res}
        ...    ALTER SEQUENCE NEW_SEQ RESTART WITH 90
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}
    ELSE
        Click On Table Cell    0    0    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings
        ...    ${res}
        ...    ALTER SEQUENCE NEW_SEQ INCREMENT BY 10
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}

        Click On Table Cell    0    1    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings
        ...    ${res}
        ...    ALTER SEQUENCE NEW_SEQ RESTART WITH 90
        ...    strip_spaces=${True}
        ...    collapse_spaces=${True}
    END

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Commiting changes'
    ...    Select Dialog
    ...    Commiting changes

Single Check
    [Arguments]    ${expected_ddl}
    Select Dialog    Commiting changes
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings
    ...    ${res}
    ...    ${expected_ddl}
    ...    strip_spaces=${True}
    ...    collapse_spaces=${True}

    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Commiting changes'
    ...    Select Dialog
    ...    Commiting changes
