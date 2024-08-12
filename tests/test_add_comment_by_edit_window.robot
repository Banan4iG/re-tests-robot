*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_alter_domain
    Init Alter    Domains (15)|ADDRESSLINE    domain
    Check Comment

test_alter_table_column
    Init Alter    Tables (10)|EMPLOYEE    table
    Edit Table Column
    Check Comment
    
test_alter_gtt_column
    Lock Employee
    Execute Immediate    CREATE GLOBAL TEMPORARY TABLE NEW_GTT (EMP_NO BIGINT) ON COMMIT DELETE ROWS
    Init Alter    Global Temporary Tables (1)|NEW_GTT    global temporary table
    Edit Table Column
    Check Comment

test_alter_view
    Init Alter    Views (1)|PHONE_LIST    view    
    Check Comment    

test_alter_procedure
    Init Alter    Procedures (10)|ALL_LANGS    procedure
    Check Comment

test_alter_procedure_input_p
    Init Proc Tab    ADD_EMP_PROJ    Input Parameters    EMP_NO

test_alter_procedure_output_p
    Init Proc Tab    ALL_LANGS    Output Parameters    CODE    

test_alter_procedure_variables
    Init Proc Tab    DELETE_EMPLOYEE    Variables    any_sales    

test_alter_procedure_cursor
    Lock Employee
    Execute Immediate    CREATE OR ALTER PROCEDURE NEW_PROC AS DECLARE test CURSOR FOR (select * from employee); BEGIN END
    Init Alter    Procedures (11)|NEW_PROC    procedure
    Select Dialog    dialog0
    Select Tab As Context    Cursors
    ${row}=    Find Table Row    0    test    Name
    Type Into Table Cell    0   ${row}    Comment     test_comment
    Send Keyboard Event    VK_ENTER
    Check Param Comment 

test_alter_function
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS begin RETURN 'five'; end
    Init Alter    Functions (1)|NEW_FUNC    function
    Check Comment

test_alter_function_argument
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC (TEST BIGINT) RETURNS VARCHAR(5) AS begin RETURN 'five'; end
    Init Func Tab    Arguments    TEST

test_alter_function_variable
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS DECLARE TEST BIGINT; begin RETURN 'five'; end
    Init Func Tab    Variables    TEST

test_alter_function_cursor
    Lock Employee
    Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS VARCHAR(5) AS DECLARE TEST CURSOR FOR (SELECT * FROM EMPLOYEE); begin RETURN 'five'; end
    Init Func Tab    Cursors    TEST

test_alter_package
    Lock Employee
    Execute Immediate    CREATE OR ALTER PACKAGE NEW_PACK AS BEGIN END
    Execute Immediate    RECREATE PACKAGE BODY NEW_PACK AS BEGIN END
    Init Alter    Packages (1)|NEW_PACK    package
    Check Comment

test_alter_trigger_for_table
    Init Alter    Table Triggers (4)|POST_NEW_ORDER    table trigger
    Check Comment

test_alter_trigger_for_ddl
    Lock Employee
    Execute Immediate    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE BEFORE ANY DDL STATEMENT POSITION 0 AS BEGIN END
    Init Alter    DDL Triggers (1)|NEW_TRIGGER    ddl trigger
    Check Comment

test_alter_trigger_for_db
    Lock Employee
    Execute Immediate    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 AS BEGIN END
    Init Alter    DB Triggers (1)|NEW_TRIGGER    db trigger
    Check Comment

test_alter_sequence
    Init Alter    Sequences (2)|EMP_NO_GEN    sequence
    Check Comment

test_alter_exception
    Init Alter    Exceptions (5)|CUSTOMER_CHECK    exception
    Check Comment

test_alter_udf
    Lock Employee
    Execute Immediate    DECLARE EXTERNAL FUNCTION NEW_UDF RETURNS BIGINT ENTRY_POINT '123' MODULE_NAME '123'
    Init alter    UDFs (1)|NEW_UDF    udf
    Check Comment

test_alter_user
    Init Alter    Users (1)|SYSDBA    user
    Check Comment

test_alter_ts
    Check Skip
    Execute Immediate    CREATE TABLESPACE NEW_TS FILE 'temp_ts.ts'
    Init Alter    Tablespaces (1)|NEW_TS    tablespace
    Check Comment
    Execute Immediate    DROP TABLESPACE NEW_TS

test_alter_job
    Check Skip
    Execute Immediate    CREATE JOB NEW_JOB '* * * * *' COMMAND ''
    Init Alter    Jobs (1)|NEW_JOB    job
    Check Comment

*** Keywords ***
Check Skip
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip If    ${{$ver != '5.0'}}

Init Alter
    [Arguments]    ${object}    ${group}
    Open connection
    Select From Tree Node Popup Menu    0    New Connection|${object}    Edit ${group}    

Check Comment
    Select Dialog    dialog0
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Check Param Comment

Check Param Comment
    Select Dialog    dialog0
    Push Button    submitButton
    Select Dialog    dialog1
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1

Edit Table Column
    Select Tab As Context    Columns
    ${row}=    Find Table Row    0    EMP_NO    Name
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    Name    2    BUTTON1_MASK

Init Proc Tab
    [Arguments]    ${proc_name}    ${tab}    ${name}
    Init Alter    Procedures (10)|${proc_name}    procedure
    Select Dialog    dialog0
    Select Tab As Context    ${tab}
    ${row}=    Find Table Row    0    ${name}    Name
    Type Into Table Cell    0   ${row}    Comment     test_comment
    Send Keyboard Event    VK_ENTER
    Check Param Comment

Init Func Tab
    [Arguments]    ${tab}    ${name}
    Init Alter    Functions (1)|NEW_FUNC   function
    Select Dialog    dialog0
    Select Tab As Context    ${tab}
    ${row}=    Find Table Row    0    ${name}    Name
    Type Into Table Cell    0   ${row}    Comment     test_comment
    Send Keyboard Event    VK_ENTER
    Check Param Comment