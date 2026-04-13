*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_configure
    ${expected_value}=    Configure Format
    Push Button    Save
    Check    ${expected_value}    ${True}

test_cancel_configure
    ${expected_value}=    Configure Format
    Push Button    Cancel
    Check    ${expected_value}    ${False}

test_exec
    Open Connection
    Select From Main Menu    View|Output Console

    Select Context    systemOutputPanel
    Select From Popup Menu    textArea    Configure RDB$TRACE_MSG format
    Select Dialog    Message format

    Clear Text Field    textField
    Type Into Text Field    textField    {msg}

    Push Button    Save
    Select Main Window
    Select Context    systemOutputPanel
    Select From Popup Menu    textArea    Enable RDB$TRACE_MSG output
    Select From Popup Menu    textArea    Clear
    Exec
    [Teardown]    Local Test Teardown

test_exec_2
    Open Connection
    Select Main Window
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    General
    Sleep    1s
    ${row}=    Find Table Row    0    RDB$TRACE_MSG output
    Click On Table Cell    0    ${row}    2

    ${row}=    Find Table Row    0    RDB$TRACE_MSG format
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    2    2    BUTTON1_MASK
    Select Dialog    Message format
    Clear Text Field    textField
    Type Into Text Field    textField    {msg}
    Push Button    Save

    Select Dialog    Preferences
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences

    Select Main Window
    Select From Main Menu    View|Output Console
    Select Context    systemOutputPanel
    Select From Popup Menu    textArea    Clear

    Select Main Window
    Exec
    [Teardown]    Local Test Teardown


*** Keywords ***
Configure Format
    Open Connection
    Select From Main Menu    View|Output Console
    Select Context    systemOutputPanel
    Select From Popup Menu    textArea    Configure RDB$TRACE_MSG format
    Select Dialog    Message format
    Clear Text Field    textField
    Type Into Text Field    textField    DB:${SPACE}
    Click On List Item    tokenList    {db} - database    2
    Type Into Text Field    textField    ${SPACE},${SPACE}
    Type Into Text Field    textField    MESSAGE:${SPACE}
    Click On List Item    tokenList    {msg} - trace message text    2
    VAR    ${expected_value}=    DB: {db} , MESSAGE: {msg}
    ${value}=    Get Text Field Value    textField
    Should Be Equal As Strings    ${value}    ${expected_value}
    RETURN    ${expected_value}

Local Test Teardown
    Select Main Window
    Select Context    systemOutputPanel
    Select From Popup Menu    textArea    Enable RDB$TRACE_MSG output
    Select Main Window
    Select From Main Menu    View|Output Console
    Test Teardown

Check
    [Arguments]    ${expected_value}    ${equal}
    Select Main Window
    Select Context    systemOutputPanel
    Select From Popup Menu    textArea    Configure RDB$TRACE_MSG format
    Select Dialog    Message format
    ${value}=    Get Text Field Value    textField
    IF    ${equal}
        Should Be Equal As Strings    ${value}    ${expected_value}
    ELSE
        Should Not Be Equal As Strings    ${value}    ${expected_value}
    END
    Close Dialog    Message format

    Select Main Window
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    General
    Sleep    1s
    ${row}=    Find Table Row    0    RDB$TRACE_MSG format
    ${value}=    Get Table Cell Value    0    ${row}    2
    IF    ${equal}
        Should Be Equal As Strings    ${value}    ${expected_value}
    ELSE
        Should Not Be Equal As Strings    ${value}    ${expected_value}
    END

    Push Button    restoreButton
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window

Exec
    Close All Tabs
    Push Button    editor-command
    Select Tab As Context    regexp=^Untitled.*
    Clear Text Field    0
    Type Into Text Field    0    select RDB$TRACE_MSG('MeSsaGE') FROM RDB$DATABASE
    Push Button    execute-script-command
    Sleep    3s
    Select Main Window
    Select Context    systemOutputPanel
    ${value}=    Get Text Field Value    textArea
    Should Contain    ${value}    MeSsaGE
