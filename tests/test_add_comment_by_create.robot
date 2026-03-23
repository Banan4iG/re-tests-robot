*** Settings ***
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_create_table
    VAR    ${title}    Create table
    Init Create    Tables (10)    ${title}    ${title}
    Init Column
    Check Comment    ${title}

test_create_table_columns
    VAR    ${title}    Create table
    Init Create    Tables (10)    ${title}    ${title}
    Init Column
    Check Column Comment

test_create_gtt
    VAR    ${title}    Create table
    Init Create    Global Temporary Tables    Create global temporary table    ${title}
    Init Column
    Check Comment    ${title}

test_create_gtt_columns
    Init Create    Global Temporary Tables    Create global temporary table    Create table
    Init Column
    Check Column Comment

test_create_view
    VAR    ${title}    Create view
    Init Create    Views (1)    ${title}    ${title}
    Select Tab As Context    Select Statement
    Clear Text Field    0
    Type Into Text Field    0    SELECT emp_no FROM employee
    Select Dialog    ${title}
    Check Comment    ${title}

test_create_procedure
    VAR    ${title}    Create procedure
    Init Create    Procedures (10)    ${title}    ${title}
    Check Comment    ${title}

test_create_procedure_input_p
    VAR    ${title}    Create procedure
    Init Create    Procedures (10)    ${title}    ${title}
    Check Procedure    Input Parameters    ${title}

test_create_procedure_output_p
    VAR    ${title}    Create procedure
    Init Create    Procedures (10)    ${title}    ${title}
    Check Procedure    Output Parameters    ${title}

test_create_procedure_variables
    VAR    ${title}    Create procedure
    Init Create    Procedures (10)    ${title}    ${title}
    Check Procedure    Variables    ${title}

test_create_procedure_cursors
    Skip    Sometimes we got java NPE
    VAR    ${title}    Create procedure
    Init Create    Procedures (10)    ${title}    ${title}
    Select Tab As Context    Cursors
    List Components In Context
    Type Into Table Cell    0    0    Name    TEST
    Type Into Table Cell    0    0    Comment    test_comment
    Click On Table Cell    0    0    Name    2
    Send Keyboard Event    VK_ENTER
    Type Into Text Field    0    select * from employee
    Send Keyboard Event    VK_ENTER
    Select Dialog    ${title}
    Push Button    submitButton
    Select Dialog    Commiting changes
    ${res}    Get Text Field Value    0
    Sleep    1s
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1
    Push Button    commitButton

test_create_function
    Check Skip 2.6
    VAR    ${title}    Create function
    Init Create    Functions    ${title}    ${title}
    Check Comment    ${title}

test_create_function_arg
    Check Skip 2.6
    VAR    ${title}    Create function
    Init Create    Functions    ${title}    ${title}
    Check Procedure    Arguments    ${title}

test_create_function_variables
    Check Skip 2.6
    VAR    ${title}    Create function
    Init Create    Functions    ${title}    ${title}
    Check Procedure    Variables    ${title}

test_create_function_cursors
    Skip    Sometimes we got java NPE
    VAR    ${title}    Create function
    Init Create    Functions    ${title}    ${title}

test_create_udf
    VAR    ${title}    Create UDF
    Init Create    UDFs    ${title}    ${title}
    Check Comment    ${title}

test_create_ts
    Skip If Embedded
    Check Skip
    VAR    ${title}    Create tablespace
    Init Create    Tablespaces    ${title}    ${title}
    Check Comment    ${title}


*** Keywords ***
Check Skip
    ${info}    Get Server Info
    ${ver}    Set Variable    ${info}[1]
    ${srv_ver}    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}

Check Skip 2.6
    ${info}    Get Server Info
    ${ver}    Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}

Init Create
    [Arguments]    ${object}    ${menu}    ${dialog}
    Lock Employee
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection|${object}    ${menu}
    Select Dialog    ${dialog}

Check Procedure
    [Arguments]    ${tab}    ${dialog}
    Select Tab As Context    ${tab}
    IF    '${tab}' == 'Variables'    Push Button    addRowButton
    Type Into Table Cell    0    0    Name    TEST
    Set Table Cell Value    0    0    Datatype    BIGINT
    Type Into Table Cell    0    0    Comment    test_comment
    Click On Table Cell    0    0    Name    2
    Send Keyboard Event    VK_ENTER
    Select Dialog    ${dialog}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('test_comment')}}    -1
    Push Button    commitButton

Init Column
    Type Into Table Cell    0    0    Name    TEST
    Set Table Cell Value    0    0    Datatype    BIGINT
    Click On Table Cell    0    0    Name    2
    Send Keyboard Event    VK_ENTER

Check Column Comment
    Type Into Table Cell    0    0    Comment    test_comment
    Send Keyboard Event    VK_ENTER
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('\'test_comment\'')}}    -1
    Push Button    commitButton

Check Comment
    [Arguments]    ${dialog}
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Select Dialog    ${dialog}
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}    Get Text Field Value    0
    Should Not Be Equal As Integers    ${{$res.find('\'test_comment\'')}}    -1
    Push Button    commitButton

# Close Create Dialog
#     [Arguments]    ${dialog}
#     Select Dialog    ${dialog}
#     Push Button    cancelButton
#     Select Dialog    Confirmation
#     Push Button    Yes
#     Select Main Window
