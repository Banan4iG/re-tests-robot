*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource
Resource            ./key.resource

Test Setup          Test Setup
Test Teardown       Local Teardown


*** Test Cases ***
test_1
    Open Connection
    Select From Tree Node Popup Menu    0    New Connection|Jobs    Create job
    Select Dialog    Create job
    Select From Combo Box    jobTypeCombo    BASH
    Select Tab As Context    Comment
    Clear Text Field    0
    Type Into Text Field    0    test_comment
    Select Dialog    Create job
    Push Button    submitButton
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings
    ...    ${res}
    ...    COMMENT ON JOB NEW_JOB_1 IS 'test_comment'
    ...    strip_spaces=${True}
    ...    collapse_spaces=${True}
