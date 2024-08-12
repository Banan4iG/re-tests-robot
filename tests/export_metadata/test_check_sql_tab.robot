*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_save_script
    Skip
    ${rdb5}=    Start
    Select Tab As Context    SQL
    Push Button    saveScriptButton
    ${script_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /script.sql
    ${test_base_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /test.fdb
    @{files}=    Create List   ${script_path}     ${test_base_path}
    Delete Files    ${files}
    Select Dialog    Save Script
    Type Into Text Field    0    ${script_path}
    Push Button    Save Script
    Sleep    2s
    Create Database   ${script_path}    ${test_base_path}
    Create Connect    ${test_base_path}
    Compare DB
    Delete Objects    ${rdb5}
    Delete Files    ${files}
    

test_execute_script
    Skip


*** Keywords ***
Start
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    VAR    ${rdb5}    ${{$ver == '5.0'}}
    Lock Employee
    Create Objects    ${rdb5}
    Push Button    extract-metadata-command
    Push Button    compareButton
    Close Dialog    Message
    RETURN    ${rdb5}

Create Connect
    [Arguments]    ${test_base_path}
    Select Window    regexp=^Red.*
    Push Button    new-connection-command
    Sleep    1s
    Type Into Text Field    3    ${test_base_path}
    Type Into Text Field    5    sysdba
    Type Into Text Field    6    masterkey
    Check Check Box    Store Password

Compare DB
    Select Window    regexp=^Red.*
    Push Button    comparerDB-command
    Select From Combo Box    dbMasterComboBox    New Connection 1
    # Push Button    selectAllAttributesButton
    Check Check Box    DOMAIN_CHECK
    Check Check Box    TABLE_CHECK
    Check Check Box    GLOBAL_TEMPORARY_CHECK
    Check Check Box    VIEW_CHECK
    Check Check Box    PROCEDURE_CHECK
    Check Check Box    FUNCTION_CHECK
    Check Check Box    PACKAGE_CHECK
    Check Check Box    TRIGGER_CHECK
    Check Check Box    DDL_TRIGGER_CHECK
    Check Check Box    DATABASE_TRIGGER_CHECK
    Check Check Box    SEQUENCE_CHECK
    Check Check Box    EXCEPTION_CHECK
    Check Check Box    EXTERNAL_FUNCTION_CHECK
    Check Check Box    ROLE_CHECK
    Check Check Box    INDEX_CHECK
    Check Check Box    TABLESPACE_CHECK
    Check Check Box    JOB_CHECK
    Check Check Box    COLLATION_CHECK
    Sleep    2s
    Push Button    compareButton
    Sleep    2s
    Select Dialog    Message
    Run Keyword And Continue On Failure    Label Text Should Be    1    Object to create - 0
    Run Keyword And Continue On Failure    Label Text Should Be    2    Object to drop - 0
    Run Keyword And Continue On Failure    Label Text Should Be    3    Object to alter - 11
    Sleep    2s

# Extract
#     Push Button    compareButton
#     Sleep    5s
#     Close Dialog    Message
#     Select Tab As Context    SQL
#     ${script}=    Get Text Field Value    0
#     RETURN    ${script}
    
# Check Ignore
#     [Arguments]    ${script}
#     @{result}    Create List    ${{$script.count("COMMENT ON")}}    ${{$script.count("COMPUTED FIELDs defining")}}    ${{$script.count("PRIMARY KEYs defining")}}    ${{$script.count("FOREIGN KEYs defining")}}    ${{$script.count("UNIQUE KEYs defining")}}    ${{$script.count("CHECK KEYs defining")}}
#     RETURN    @{result}