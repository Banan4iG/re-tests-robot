*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_alter_table
    Skip If Embedded
    Init Alter    Tables (10)|EMPLOYEE
    Check Table Comment    EMPLOYEE    TABLE

test_alter_gtt
    Skip If Embedded
    Lock Employee
    Execute Immediate    CREATE GLOBAL TEMPORARY TABLE NEW_GTT (TESTS BIGINT) ON COMMIT DELETE ROWS
    Init Alter    Global Temporary Tables (1)|NEW_GTT
    Check Table Comment    NEW_GTT    GLOBAL TEMPORARY

test_alter_procedure
    Init Alter    Procedures (10)|ALL_LANGS
    Check Comment    ALL_LANGS    PROCEDURE

test_alter_procedure_input_p
    Check Proc Tab Comment    Procedures (10)    ADD_EMP_PROJ    Input Parameters    EMP_NO

test_alter_procedure_output_p
    Check Proc Tab Comment    Procedures (10)    ALL_LANGS    Output Parameters    CODE

test_alter_procedure_variables
    Check Proc Tab Comment    Procedures (10)    DELETE_EMPLOYEE    Variables    any_sales

test_alter_procedure_cursor
    Lock Employee
    Execute Immediate
    ...    CREATE OR ALTER PROCEDURE NEW_PROC AS DECLARE test CURSOR FOR (select * from employee); BEGIN END
    Check Proc Tab Comment    Procedures (11)    NEW_PROC    Cursors    test

test_alter_function
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
    Init Alter    Functions (1)|NEW_FUNC
    Check Comment    NEW_FUNC    FUNCTION

test_alter_package
    Check Skip 2.6
    Lock Employee
    Execute Immediate    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN END
    Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    Init Alter    Packages (1)|NEW_PACK
    Check Comment    NEW_PACK    PACKAGE

test_alter_sequence
    Init Alter    Sequences (2)|EMP_NO_GEN
    Check Comment    EMP_NO_GEN    SEQUENCE

test_alter_exception
    Init Alter    Exceptions (5)|CUSTOMER_CHECK
    Check Comment    CUSTOMER_CHECK    EXCEPTION

test_alter_udf
    Lock Employee
    Execute Immediate    DECLARE EXTERNAL FUNCTION NEW_UDF RETURNS BIGINT ENTRY_POINT '123' MODULE_NAME '123'
    Init alter    UDFs (1)|NEW_UDF
    Check Comment    NEW_UDF    EXTERNAL FUNCTION

test_alter_ts
    Check Skip
    Lock Employee
    Execute Immediate    CREATE TABLESPACE NEW_TS FILE 'test_alter.ts'
    Init Alter    Tablespaces (1)|NEW_TS
    Check Comment    NEW_TS    TABLESPACE

test_alter_job
    Skip If Embedded
    Check Skip
    Execute Immediate    CREATE JOB NEW_JOB '* * * * *' COMMAND ''
    Init Alter    Jobs (1)|NEW_JOB
    Check Comment    NEW_JOB    JOB
    Execute Immediate    DROP JOB NEW_JOB


*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}

Check Skip 2.6
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}

Init Alter
    [Arguments]    ${object}
    Open Connection
    Click On Tree Node    0    New Connection|${object}    2

Check Comment
    [Arguments]    ${name}    ${type}
    Select Tab As Context    ${name}:${type}:New Connection
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Init Commit Window

Init Commit Window
    Select Main Window
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1
    Push Button    rollbackButton

Check Table Comment
    [Arguments]    ${name}    ${type}
    Select Tab As Context    ${name}:${type}:New Connection
    Select Tab As Context    Properties
    Clear Text Field    1
    Type Into Text Field    1    test_comment
    Push Button    Save
    ${res}=    Execute    select RDB$DESCRIPTION from RDB$RELATIONS where RDB$DESCRIPTION is not NULL
    Sleep    1s
    Clear Text Field    1
    Push Button    Save
    Should Be Equal    ${res}    [('test_comment',)]

Check Proc Tab Comment
    [Arguments]    ${group_name}    ${proc_name}    ${tab}    ${name}
    Init Alter    ${group_name}|${proc_name}
    Select Tab As Context    ${proc_name}:PROCEDURE:New Connection
    Select Tab As Context    ${tab}
    ${row}=    Find Table Row    0    ${name}    Name
    Type Into Table Cell    0    ${row}    Comment    test_comment
    Send Keyboard Event    VK_ENTER
    Init Commit Window
