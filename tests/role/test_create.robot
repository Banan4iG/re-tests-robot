*** Settings ***
Library         RemoteSwingLibrary
Resource        ../../files/keywords.resource
Test Setup      Setup before every tests
Test Teardown   Teardown after every tests

*** Test Cases ***
Test Create Role Simple
    Init Role    NEW_ROLE_1    ${EMPTY}
    Check Role    CREATE ROLE NEW_ROLE_1    NEW_ROLE_1

Test Create Role With Space
    Init Role    "Role With Spaces"    ${EMPTY}
    Check Role    CREATE ROLE """ROLE WITH SPACES"""    "ROLE WITH SPACES"

Test Create Role With Description
    Init Role    NEW_ROLE_2    test_description
    Check Role    COMMENT ON ROLE NEW_ROLE_2 IS 'test_description'    NEW_ROLE_2


*** Keywords ***

Init Role
    [Arguments]    ${name}    ${description}
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Sleep    1s
    Select From Tree Node Popup Menu    0    New Connection|Roles (0)    Create role
    Select Dialog    Create role
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${name}

    Run Keyword If    """${description}""" != """${EMPTY}"""    Fill Description Field    ${description}

    Push Button    submitButton

Fill Description Field
    [Arguments]    ${description}
    Clear Text Field    1
    Type Into Text Field    1    ${description}

Check Role
    [Arguments]    ${text}    ${name}
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${text}
    Push Button    commitButton
    Sleep    0.1s
    ${old}=    Set Jemmy Timeout    DialogWaiter.WaitDialogTimeout	0
    Run Keyword And Expect Error
    ...    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create role'
    ...    Select Dialog    Create role
    Select Main Window
    Tree Node Should Exist    0     New Connection|Roles (1)|${name}