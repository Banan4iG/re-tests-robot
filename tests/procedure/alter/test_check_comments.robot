*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Init Comment Tab
    Init Commit Window

test_2
    Init Comment Tab
    Push Button    updateCommentButton
    Sleep    1s
    Check Comment

    Open Connection
    Click On Tree Node    0    New Connection|Procedures (10)|ALL_LANGS    2
    Select Tab As Context    ALL_LANGS:PROCEDURE:New Connection
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment123
    Push Button    rollbackCommentButton
    Check Comment

test_input_p
    Check Proc Tab Comment    Procedures (10)    ADD_EMP_PROJ    Input Parameters    EMP_NO

test_output_p
    Check Proc Tab Comment    Procedures (10)    ALL_LANGS    Output Parameters    CODE

test_variables
    Check Proc Tab Comment    Procedures (10)    DELETE_EMPLOYEE    Variables    any_sales

test_cursor
    Lock Employee
    Execute Immediate
    ...    CREATE OR ALTER PROCEDURE NEW_PROC AS DECLARE test CURSOR FOR (select * from employee); BEGIN END
    Check Proc Tab Comment    Procedures (11)    NEW_PROC    Cursors    test


*** Keywords ***
Init Comment Tab
    Lock Employee
    Open Connection
    Click On Tree Node    0    New Connection|Procedures (10)|ALL_LANGS    2
    Select Tab As Context    ALL_LANGS:PROCEDURE:New Connection
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment

Check Comment
    Close All Tabs
    Close Connection
    ${res}=    Execute    select RDB$DESCRIPTION from RDB$PROCEDURES where RDB$DESCRIPTION is not NULL
    Should Be Equal    ${res}    [('test_comment',)]

Check Proc Tab Comment
    [Arguments]    ${group_name}    ${proc_name}    ${tab}    ${name}
    Lock Employee
    Open Connection
    Click On Tree Node    0    New Connection|${group_name}|${proc_name}    2
    Select Tab As Context    ${proc_name}:PROCEDURE:New Connection
    Select Tab As Context    ${tab}
    ${row}=    Find Table Row    0    ${name}    Name
    Type Into Table Cell    0    ${row}    Comment    test_comment
    Click On Table Cell    0    ${row}    Name
    Init Commit Window

Init Commit Window
    Select Main Window
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    IF    '${TEST_NAME}' == 'test_variables' or '${TEST_NAME}' == 'test_cursor'
        ${row}=    Find Table Row    0    CREATE OR ALTER PROCEDURE    Name operation
    ELSE
        ${row}=    Find Table Row    0    ADD COMMENT    Name operation
    END
    Click On Table Cell    0    ${row}    Name operation
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1
    Push Button    commitButton
