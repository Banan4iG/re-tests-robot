*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Variables ***
${TEST_USERNAME}    TEST_USER
${TEST_USER_PASSWORD}    TEST
${TEST_NEW_USER_FIRST_NAME}    TEST_USER_FNAME
${TEST_NEW_USER_MIDDLE_NAME}    TEST_USER_MNAME
${TEST_NEW_USER_LAST_NAME}    TEST_USER_LNAME
${FIELD_INDEX_FIRST_NAME}    firstNameField
${FIELD_INDEX_MIDDLE_NAME}    middleNameField
${FIELD_INDEX_LAST_NAME}    lastNameField

*** Test Cases ***
test_edit_first_name
    Edit And Verify User Field    ${FIELD_INDEX_FIRST_NAME}    ${TEST_NEW_USER_FIRST_NAME}

test_verify_first_name_after_app_reopen
    Verify User Field After Reload    ${FIELD_INDEX_FIRST_NAME}    ${TEST_NEW_USER_FIRST_NAME}

test_edit_middle_name
    Edit And Verify User Field    ${FIELD_INDEX_MIDDLE_NAME}    ${TEST_NEW_USER_MIDDLE_NAME}

test_verify_middle_name_after_app_reopen
    Verify User Field After Reload    ${FIELD_INDEX_MIDDLE_NAME}    ${TEST_NEW_USER_MIDDLE_NAME}

test_edit_last_name
    Edit And Verify User Field    ${FIELD_INDEX_LAST_NAME}    ${TEST_NEW_USER_LAST_NAME}

test_verify_last_name_after_app_reopen
    Verify User Field After Reload    ${FIELD_INDEX_LAST_NAME}    ${TEST_NEW_USER_LAST_NAME}

test_edit_flags
    Create User    ${TEST_USERNAME}    ${TEST_USER_PASSWORD}
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    2s
    UnCheck Check Box    isActiveCheck
    Check Check Box      isAdminCheck
    Sleep    2s
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Select Main Window
    Checkbox Should Be Unchecked    isActiveCheck
    Checkbox Should Be Checked      isAdminCheck

test_verify_flags_after_app_reopen
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s
    Checkbox Should Be Unchecked    isActiveCheck
    Checkbox Should Be Checked      isAdminCheck
    [Teardown]    Drop User    ${TEST_USERNAME}

test_add_and_edit_tags
    Create User    ${TEST_USERNAME}    ${TEST_USER_PASSWORD}
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s

    Push Button    addTagButton
    Type Into Table Cell    tagTable    0    Tag      pc
    Type Into Table Cell    tagTable    0    Value    123

    Push Button    addTagButton
    Type Into Table Cell    tagTable    1    Tag    Card

    Sleep    0.5s
    Push Button    Apply
    Sleep    0.2s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    2s

    Select Main Window
    @{values}=    Get Table Values    tagTable
    Should Be Equal As Strings    ${values}    [['pc', '123'], ['Card', '']]
    [Teardown]    Drop User    ${TEST_USERNAME}

test_precreated_and_added_tags
    Execute Immediate    CREATE USER ${TEST_USERNAME} PASSWORD '${TEST_USER_PASSWORD}' ACTIVE USING PLUGIN Srp TAGS (CARD = '123', PC = '999')

    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${TEST_USERNAME}    Edit user
    Sleep    1s

    @{tags}=    Get Table Values    tagTable
    ${sorted_initial}=  Evaluate    sorted(${tags})
    Should Be Equal As Strings    ${sorted_initial}    [['CARD', '123'], ['PC', '999']]

    Push Button    addTagButton
    Type Into Table Cell    tagTable    2    Tag      Added1
    Type Into Table Cell    tagTable    2    Value    val1

    Push Button    addTagButton
    Type Into Table Cell    tagTable    3    Tag      Added2
    Type Into Table Cell    tagTable    3    Value    val2

    Sleep    0.2s
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    1s

    Select Main Window
    @{final_tags}=    Get Table Values    tagTable
    ${sorted_final}=  Evaluate    sorted(${final_tags})
    Should Be Equal As Strings    ${sorted_final}    [['Added1', 'val1'], ['Added2', 'val2'], ['CARD', '123'], ['PC', '999']]

    [Teardown]    Drop User    ${TEST_USERNAME}

*** Keywords ***
Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    Skip if   ${{$ver == '2.6'}}
    Setup before every tests

Create User
    [Arguments]    ${username}    ${password}
    Execute Immediate    CREATE USER ${username} PASSWORD '${password}' ACTIVE USING PLUGIN Srp

Drop User
    [Arguments]    ${user_name}
    Teardown after every tests
    Run Keyword And Ignore Error    Execute Immediate    DROP USER ${user_name}

Edit User
    [Arguments]    ${field_name}    ${new_value}    ${user_name}
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (2)|${user_name}    Edit user
    Sleep    2s
    Select Tab    Properties
    Sleep    1s
    Type Into Text Field    ${field_name}    ${new_value}
    Push Button    Apply
    Sleep    0.1s
    Select Dialog    Commiting changes
    Push Button    commitButton
    Sleep    1s

Check Updated Text Field
    [Arguments]    ${field_name}    ${predict}
    Select Main Window
    ${textFieldValue}=    Get Text Field Value    ${field_name}
    Should Be Equal As Strings    ${textFieldValue}    ${predict}

Edit And Verify User Field
    [Arguments]    ${field_name}    ${new_value}
    Create User    ${TEST_USERNAME}    ${TEST_USER_PASSWORD}
    Edit User    ${field_name}    ${new_value}    ${TEST_USERNAME}
    Check Updated Text Field    ${field_name}    ${new_value}

Verify User Field After Reload
    [Arguments]    ${field_name}    ${new_value}
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Click On Tree Node    0    New Connection|Users (2)|${TEST_USERNAME}    clickCount=2
    Sleep    2s
    Check Updated Text Field    ${field_name}    ${new_value}
    [Teardown]    Drop User    ${TEST_USERNAME}
