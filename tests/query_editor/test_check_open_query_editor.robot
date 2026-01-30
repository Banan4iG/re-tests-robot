*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_empty_saved
    Open Connection
    Sleep    2s
    ${result1}=    Get Text Field Value    0
    Open Connection
    Open Connection
    Sleep    2s
    ${result2}=    Get Text Field Value    0
    Should Be Equal    ${result1}    ${EMPTY}
    Should Be Equal    ${result2}    ${EMPTY}

test_empty
    Delete Query Files
    Open Connection
    Sleep    2s
    ${result1}=    Get Text Field Value    0
    Open Connection
    Open Connection
    Sleep    2s
    ${result2}=    Get Text Field Value    0
    Sleep    1s
    Should Be Equal    ${result1}    ${EMPTY}
    Should Be Equal    ${result2}    ${EMPTY}

test_saved
    Open Connection
    Sleep    2s
    Type Into Text Field    0    select * from employee;
    Open Connection
    Open Connection
    Sleep    2s
    ${result1}=    Get Text Field Value    0
    Open Connection
    Open Connection
    Sleep    2s
    ${result2}=    Get Text Field Value    0
    Clear Text Field    0
    Should Be Equal    ${result1}    select * from employee;    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal    ${result2}    select * from employee;    strip_spaces=${True}    collapse_spaces=${True}
