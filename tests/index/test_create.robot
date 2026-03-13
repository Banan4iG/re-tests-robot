*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_check_order_fields
    Init
    Select From Combo Box    tableCombo    EMPLOYEE
    Push Button    sortAvailableButton
    Click On List Item    0    0    2
    Push Button    selectOneButton
    @{list}=    Get List Values    1
    Should Be Equal As Strings    ${list}    ['EMP_NO', 'FIRST_NAME']
    Push Button    selectAllButton

    Click On List Item    1    0

    Push Button    movePageDownButton
    Push Button    moveUpButton
    @{list}=    Get List Values    1
    Should Be Equal As Strings    ${list}    ['FIRST_NAME', 'FULL_NAME', 'HIRE_DATE', 'JOB_CODE', 'JOB_COUNTRY', 'JOB_GRADE', 'LAST_NAME', 'PHONE_EXT', 'EMP_NO', 'SALARY']

    Push Button    movePageUpButton
    Push Button    moveDownButton
    @{list}=    Get List Values    1
    Should Be Equal As Strings    ${list}    ['FIRST_NAME', 'EMP_NO', 'FULL_NAME', 'HIRE_DATE', 'JOB_CODE', 'JOB_COUNTRY', 'JOB_GRADE', 'LAST_NAME', 'PHONE_EXT', 'SALARY']

    Push Button    sortSelectedButton
    @{list}=    Get List Values    1
    Should Be Equal As Strings    ${list}    ['EMP_NO', 'FIRST_NAME', 'FULL_NAME', 'HIRE_DATE', 'JOB_CODE', 'JOB_COUNTRY', 'JOB_GRADE', 'LAST_NAME', 'PHONE_EXT', 'SALARY']

    Click On List Item    1    0
    Push Button    removeOneButton
    @{list}=    Get List Values    0
    Should Be Equal As Strings    ${list}    ['EMP_NO']

    Click On List Item    1    0
    Push Button    movePageDownButton
    Push Button    moveUpButton
    Push Button    removeAllButton
    @{list}=    Get List Values    0
    Should Be Equal As Strings    ${list}    ['EMP_NO', 'FULL_NAME', 'HIRE_DATE', 'JOB_CODE', 'JOB_COUNTRY', 'JOB_GRADE', 'LAST_NAME', 'PHONE_EXT', 'FIRST_NAME', 'SALARY']

    Push Button    sortAvailableButton
    @{list}=    Get List Values    0
    Should Be Equal As Strings    ${list}    ['EMP_NO', 'FIRST_NAME', 'FULL_NAME', 'HIRE_DATE', 'JOB_CODE', 'JOB_COUNTRY', 'JOB_GRADE', 'LAST_NAME', 'PHONE_EXT', 'SALARY']

    Push Button    cancelButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window
    # Check    123    TEST_INDEX

test_condition
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Init    TEST INDEX
    Push Button    sortAvailableButton
    Click On List Item    0    0    2
    Select From Combo Box    sortingCombo    DESCENDING
    Uncheck Check Box    activeCheck
    Check Check Box    uniqueCheck

    Select Tab As Context    Condition
    Clear Text Field    0
    Type Into Text Field    0    1 = 1

    Check
    ...    text=CREATE UNIQUE DESCENDING INDEX "TEST INDEX" ON COUNTRY ( COUNTRY ) WHERE 1 = 1
    ...    name=TEST INDEX
    ...    text2=ALTER INDEX "TEST INDEX" INACTIVE

test_select_ts
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
    Init    "TEST INDEX"
    Push Button    sortAvailableButton
    Click On List Item    0    0    2

    Select From Combo Box    tablespaceCombo    NEW_TS

    Check
    ...    text=CREATE INDEX """TEST INDEX""" ON COUNTRY ( COUNTRY )
    ...    name="TEST INDEX"
    ...    ts=NEW_TS

test_computed_by_with_comment
    Init
    Check Check Box    computedCheck
    Select Tab As Context    Computed By
    Clear Text Field    0
    Type Into Text Field    0    '1' || '1'

    Select Main Window
    Select Dialog    Create index
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment

    Check
    ...    text=CREATE INDEX TEST_INDEX ON COUNTRY COMPUTED BY ('1' || '1')
    ...    text2=COMMENT ON INDEX TEST_INDEX IS 'test_comment'


*** Keywords ***
Init
    [Arguments]    ${name}=TEST_INDEX
    Lock Employee
    IF    '${TEST_NAME}' == 'test_select_ts'
        Execute Immediate    CREATE TABLESPACE NEW_TS FILE '${TEMPDIR}${/}new_ts.ts'
    END
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection|Indices (38)    Create index
    Select Dialog    Create index
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

Check
    [Arguments]    ${text}    ${name}=TEST_INDEX    ${text2}=${EMPTY}    ${ts}=PRIMARY
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
        VAR    ${check_ts}=    ${SPACE}TABLESPACE ${ts}
    ELSE
        VAR    ${check_ts}=    ${EMPTY}
    END

    Select Dialog    Create index
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s

    IF    '${TEST_NAME}' == 'test_condition' or '${TEST_NAME}' == 'test_computed_by_with_comment'
        Click On Table Cell    0    0    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${text}${check_ts}    strip_spaces=${True}    collapse_spaces=${True}

        Click On Table Cell    0    1    Name operation
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${text2}    strip_spaces=${True}    collapse_spaces=${True}
    ELSE
        ${res}=    Get Text Field Value    0
        Should Be Equal As Strings    ${res}    ${text}${check_ts}    strip_spaces=${True}    collapse_spaces=${True}
    END
    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout    0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create index'
    ...    Select Dialog
    ...    Create index

    Select Main Window
    Tree Node Should Exist    0    New Connection|Indices (39)|${name}
