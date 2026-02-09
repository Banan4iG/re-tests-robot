*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Local Teardown


*** Test Cases ***
test_ignore
    Action    [10, 0, 0, 0, 0, 0]

test_not_ignore
    Action    [10, 1, 3, 10, 14, 2]


*** Keywords ***
Check Ignore
    [Arguments]    ${script}
    @{result}=    Create List
    ...    ${{$script.count("CREATE TABLE")}}
    ...    ${{$script.count("COMMENT ON")}}
    ...    ${{$script.count("COMPUTED BY")}}
    ...    ${{$script.count("PRIMARY KEY")}}
    ...    ${{$script.count("FOREIGN KEY")}}
    ...    ${{$script.count("UNIQUE")}}
    RETURN    @{result}

Action
    [Arguments]    ${expected_result}
    Execute Immediate    COMMENT ON TABLE EMPLOYEE IS 'comment'
    Open Connection
    Select From Main Menu    Tools|ER-diagram editor
    Push Button    updateFromDatabase
    Select Dialog    Generate ERD
    Push Button    selectAllButton
    Push Button    Generate
    Sleep    2s
    Select Main Window
    Push Button    generateScriptsButton
    IF    '${TEST_NAME}' == 'test_ignore'
        Push Button    selectAllExtractPropertiesButton
    END
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    DB Metadata Export
    Select Tab As Context    SQL
    ${script}=    Get Text Field Value    0
    @{result}=    Check Ignore    ${script}
    Should Be Equal As Strings    ${result}    ${expected_result}

Local Teardown
    Select Main Window
    Run Keyword In Separate Thread    Click On Component    regexp=^closeTabLabel for "Entity Relationship Diagram.*    clickCountString=1    buttonString=BUTTON1_MASK
    # Thread
    Sleep    10
    Select Dialog    Confirmation
    Push Button    No
    Select Main Window
    Test Teardown
