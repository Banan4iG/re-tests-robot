*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_change_field
    Init    "TEST INDEX"    TEST INDEX
    Select From Combo Box    tableCombo    EMPLOYEE
    Select From Combo Box    sortingCombo    DESCENDING
    Click On List Item    0    0    2
    Check
    ...    text=CREATE DESCENDING INDEX "TEST INDEX" ON EMPLOYEE ( EMP_NO )
    ...    name=TEST INDEX

test_select_ts
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
    Init    """TEST INDEX"""
    Select From Combo Box    tablespaceCombo    NEW_TS

    Check
    ...    text=ALTER INDEX """TEST INDEX""" SET
    ...    name="TEST INDEX"
    ...    ts=NEW_TS

test_active
    Init
    Uncheck Check Box    activeCheck
    Check
    ...    text=ALTER INDEX TEST_INDEX INACTIVE

test_condition
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Init
    Check Check Box    uniqueCheck

    Select Tab As Context    Condition
    Clear Text Field    0
    Type Into Text Field    0    1 = 1

    Check
    ...    text=CREATE UNIQUE INDEX TEST_INDEX ON COUNTRY ( COUNTRY ) WHERE 1 = 1

test_computed_by_with_comment
    Init
    Check Check Box    computedCheck
    Select Tab As Context    Computed By
    Clear Text Field    0
    Type Into Text Field    0    '1' || '1'

    Select Main Window
    Select Tab As Context    TEST_INDEX:INDEX:New Connection
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Check
    ...    text=CREATE INDEX TEST_INDEX ON COUNTRY COMPUTED BY ('1' || '1')
    ...    text2=COMMENT ON INDEX TEST_INDEX IS 'test_comment'

test_statistic
    Init
    Select Tab As Context    Statistic (selectivity)
    @{headers}=    Get Table Headers    0
    Should Be Equal As Strings    ${headers}    ['Field Name', 'Statistic (selectivity)', 'Field Position']


*** Keywords ***
Init
    [Arguments]    ${create_name}=TEST_INDEX    ${tree_name}=TEST_INDEX    ${sql}=CREATE INDEX ${create_name} ON COUNTRY (COUNTRY);
    Lock Employee
    Execute Immediate    ${sql}
    IF    '${TEST_NAME}' == 'test_select_ts'
        Execute Immediate    CREATE TABLESPACE NEW_TS FILE '${TEMPDIR}${/}new_ts.ts'
    END
    Open Connection
    Click On Tree Node    0    New Connection|Indices (39)|${tree_name}    2
    Select Tab As Context    ${tree_name}:INDEX:New Connection
    ${name}=    Get Text Field Value    nameField
    Should Be Equal As Strings    ${tree_name}    ${name}

Check
    [Arguments]    ${text}    ${name}=TEST_INDEX   ${text2}=${EMPTY}    ${ts}=PRIMARY
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        VAR    ${check_ts}=    ${SPACE}TABLESPACE ${ts}
    ELSE
        VAR    ${check_ts}=    ${EMPTY}
    END

    Select Main Window
    Select Tab As Context    ${name}:INDEX:New Connection
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s

    IF    '${TEST_NAME}' == 'test_change_field' or '${TEST_NAME}' == 'test_computed_by_with_comment' or '${TEST_NAME}' == 'test_condition'
        ${value}=    Get Table Cell Value    0    0    Name operation
        Should Be Equal As Strings    ${value}    DROP INDEX

        Click On Table Cell    0    1    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${text}${check_ts}    strip_spaces=${True}    collapse_spaces=${True}

        IF    ${text2}
            Click On Table Cell    0    2    Name operation
            ${res}=    Get Text Field Value    0
            Should Be Equal As Strings    ${res}    ${text2}    strip_spaces=${True}    collapse_spaces=${True}
        END
    ELSE
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${text}${check_ts}    strip_spaces=${True}    collapse_spaces=${True}
    END

    Push Button    commitButton

    Select Main Window
    Select Tab As Context    ${name}:INDEX:New Connection
    Select Tab As Context    DDL to Create
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}${check_ts}    strip_spaces=${True}    collapse_spaces=${True}
