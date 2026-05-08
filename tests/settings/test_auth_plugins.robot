*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Local Test Teardown


*** Test Cases ***
test_1
    Open Authentication Plugins
    Uncheck Check Box    Gss
    Uncheck Check Box    Multifactor
    Uncheck Check Box    OpenIDConnect
    Uncheck Check Box    Legacy_Auth
    Apply Settings
    Check Auth Plugins    ['authPlugins', 'Certificate,GostPassword,Srp,Srp224,Srp256,Srp384,Srp512']

test_2
    Open Authentication Plugins
    Uncheck All Checkboxes
    Apply Settings
    Check Auth Plugins    ['authPlugins', '']


*** Keywords ***
Open Authentication Plugins
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Connection
    ${row}=    Find Table Row    0    Allowed authentication plugins by default
    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    2    2    BUTTON1_MASK
    Select Dialog    Authentication Plugins by default

Apply Settings
    Push Button    Save
    Select Dialog    Preferences
    Push Button    applyButton
    Close Dialog    Message
    Close Dialog    Preferences
    Select Main Window

Check Auth Plugins
    [Arguments]    ${expected_value}
    ${row}=    Open Connection Properties
    Click On Table Cell    0    ${row}    Key
    Push Button    Delete
    Select Main Window
    Open Connection
    Sleep    0.5s
    Close Connection
    ${row}=    Open Connection Properties
    @{values}=    Get Table Row Values    0    ${row}
    Should Be Equal As Strings    ${values}    ${expected_value}

Open Connection Properties
    Select From Tree Node Popup Menu    0    New Connection    Connection properties
    Select Tab As Context    Database Browser
    Select Tab As Context    Advanced
    ${row}=    Find Table Row    0    authPlugins    Key
    RETURN    ${row}

Local Test Teardown
    Select Main Window
    Select From Main Menu    System|Preferences
    Sleep    0.5s
    Select Dialog    Preferences
    Push Button    restoreButton
    Push Button    OK
    Select Dialog    Message
    Push Button    OK
    Select Main Window
    Test Teardown
