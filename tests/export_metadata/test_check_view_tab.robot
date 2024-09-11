*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
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
    ${node_names}=    Get Tree Node Child Names    dbComponentsTree    Objects To Create
    IF  ${rdb5}
        ${expected_names}=    Create List    Domains (15)    Tables (10)    Global Temporary Tables (1)    Views (1)    Procedures (10)    Functions (1)    Packages (1)    Table Triggers (4)    DDL Triggers (1)    DB Triggers (1)    Sequences (2)    Exceptions (5)    UDFs (1)    Roles (1)    Indices (12)    Tablespaces    Jobs (1)    Collations (1)
    ELSE
        ${expected_names}=    Create List    Domains (15)    Tables (10)    Global Temporary Tables (1)    Views (1)    Procedures (10)    Functions (1)    Packages (1)    Table Triggers (4)    DDL Triggers (1)    DB Triggers (1)    Sequences (2)    Exceptions (5)    UDFs (1)    Roles (1)    Indices (12)    Collations (1)   
    END
    Should Be Equal As Strings    ${node_names}    ${expected_names}
    Delete Objects    ${rdb5}