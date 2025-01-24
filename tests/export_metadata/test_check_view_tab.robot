*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_full_list
    ${rdb5}=    Export
    ${node_names}=    Get Tree Node Child Names    dbComponentsTree    Objects To Create
    IF  ${rdb5}
        ${expected_names}=    Create List    Domains (15)    Tables (10)    Global Temporary Tables (1)    Views (1)    Procedures (10)    Functions (1)    Packages (1)    Table Triggers (4)    DDL Triggers (1)    DB Triggers (1)    Sequences (2)    Exceptions (5)    UDFs (1)    Roles (1)    Indices (12)    Tablespaces    Jobs    Collations (1)
    ELSE
        ${expected_names}=    Create List    Domains (15)    Tables (10)    Global Temporary Tables (1)    Views (1)    Procedures (10)    Functions (1)    Packages (1)    Table Triggers (4)    DDL Triggers (1)    DB Triggers (1)    Sequences (2)    Exceptions (5)    UDFs (1)    Roles (1)    Indices (12)    Collations (1)   
    END
    Should Be Equal As Strings    ${node_names}    ${expected_names}
    # Delete Objects    ${rdb5}

test_check_node
    ${rdb5}=    Export
    Click On Tree Node    dbComponentsTree    Objects To Create|Tables (10)|COUNTRY
    ${script}=    Get Text Field Value    0
    Should Be Equal As Strings    ${script}    CREATE TABLE COUNTRY ( COUNTRY COUNTRYNAME NOT NULL, CURRENCY VARCHAR(10) NOT NULL);    strip_spaces=${True}    collapse_spaces=${True}
    # Delete Objects    ${rdb5}

test_double_click_node
    ${rdb5}=    Export
    Click On Tree Node    dbComponentsTree    Objects To Create|Tables (10)|COUNTRY    clickCount=2
    ${script}=    Get Text Field Value    0
    Sleep    2s
    Should Not Be Equal As Strings    ${script}    ${EMPTY}
    # Delete Objects    ${rdb5}

*** Keywords ***
Export
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    VAR    ${rdb5}    ${{$ver == '5.0'}}
    Lock Employee  
    Create Objects    ${rdb5}
    Push Button    extract-metadata-command
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    View
    Select Window    regexp=^Red.*
    RETURN    ${rdb5}