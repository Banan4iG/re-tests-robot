*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    ${conf_path}=    Iinit Build
    Uncheck Check Box    log_trigger_finish
    Uncheck Check Box    log_context
    Uncheck Check Box    log_errors
    Uncheck Check Box    log_warnings
    Uncheck Check Box    print_plan
    Uncheck Check Box    print_perf
    Uncheck Check Box    log_blr_requests
    Uncheck Check Box    print_blr
    Uncheck Check Box    log_dyn_requests
    Uncheck Check Box    print_dyn
    Uncheck Check Box    log_privilege_changes
    Uncheck Check Box    log_changes_only
    Uncheck Check Box    log_services
    Type Into Text Field    0    ship
    Type Into Text Field    1    819
    Type Into Text Field    2    14
    Type Into Text Field    3    true
    
    Clear Text Field    8
    Type Into Text Field    8     1024
    Clear Text Field    9
    Type Into Text Field    9     2048
    Clear Text Field    10
    Type Into Text Field    10    4096
    Clear Text Field    11
    Type Into Text Field    11    8192
    
    Finish Build    ${conf_path}    0
    
        

test_2
    ${conf_path}=    Iinit Build
    Uncheck Check Box    log_security_incidents
    Uncheck Check Box    log_initfini
    Uncheck Check Box    log_connections
    Uncheck Check Box    log_transactions
    Uncheck Check Box    log_statement_prepare
    Uncheck Check Box    log_statement_free
    Uncheck Check Box    log_statement_start
    Uncheck Check Box    log_statement_finish
    Uncheck Check Box    log_procedure_start
    Uncheck Check Box    log_procedure_finish
    Uncheck Check Box    log_function_start
    Uncheck Check Box    log_function_finish
    Uncheck Check Box    log_trigger_start
    Uncheck Check Box    log_service_query

    Type Into Text Field    4    ship
    Type Into Text Field    5    819
    Type Into Text Field    6    14
    Type Into Text Field    7    true
    
    Clear Text Field    12
    Type Into Text Field    12     1024
    Clear Text Field    13
    Type Into Text Field    13     2048
    Clear Text Field    14
    Type Into Text Field    14    4096

    Finish Build    ${conf_path}    1

*** Keywords ***
Iinit Build
    ${conf_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /test_conf.conf
    Open connection
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Push Button    newConfigButton
    Select Dialog    Build configuration file
    Select From Combo Box    0    RedDatabase 3.0
    RETURN    ${conf_path}

Finish Build
    [Arguments]    ${conf_path}    ${number}
    Type Into Text Field    15    ${conf_path}
    Push Button    Save
    Select Dialog    Message
    Push Button    OK
    Close Dialog    Build configuration file
    Check Build Config    ${conf_path}    ${number}