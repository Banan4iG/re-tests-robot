*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../../files/keywords.resource
Resource            keys.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Variables ***
# d - day of month
# E - day of week
# G - era
# h - 12 hour
# H - 24 hour
# m - minute of hour
# M - month of year
# n - nano of second
# a - part of day (am/pm)
# Q - quarter of year
# s - second of minute
# w - week of year
# W - week of month
# y - year of era
# X - timezone offset
# O - localized timezone offset
@{DATE}    G - era    y - year of era    M - month of year    d - day of month    Q - quarter of year    w - week of year    W - week of month    E - day of week
@{TIME}    a - part of day (am/pm)    h - 12 hour    H - 24 hour    m - minute of hour    s - second of minute    n - nano of second
@{TIMEZONE}    O - localized timezone offset    X - timezone offset


*** Test Cases ***
test_1
    VAR    @{params}    @{DATE}
    Test    Date Pattern Format    ${params}    GyMdQwWE

test_2
    VAR    @{params}    @{TIME}
    Test    Time Pattern Format    ${params}    ahHmsn

test_3
    VAR    @{params}    @{DATE}    @{TIME}
    Test    Timestamp Pattern Format    ${params}    GyMdQwWEahHmsn

test_4
    Check Skip
    VAR    @{params}    @{TIME}    @{TIMEZONE}
    Test    Time with timezone Pattern Format    ${params}    ahHmsnOX

test_5
    Check Skip
    VAR    @{params}    @{DATE}    @{TIME}    @{TIMEZONE}
    Test    Timestamp with timezone Pattern Format    ${params}    GyMdQwWEahHmsnOX


*** Keywords ***
Test
    [Arguments]    ${pattern_name}    ${expected_params}    ${result}
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Click On Tree Node    0    Result Set Table
    Sleep    2s
    ${row}=    Find Table Row    0    ${pattern_name}

    Run Keyword In Separate Thread    Click On Table Cell    0    ${row}    2    2    BUTTON1_MASK
    Select Dialog    Date/time format
    Clear Text Field    textField
    Get List Values    0
    # Should Be Equal As Strings   ${params}    ${expected_params}
    FOR    ${param}    IN    @{expected_params}
        Click On List Item    0    ${param}    2
    END

    ${value}=    Get Text Field Value    textField
    Should Be Equal As Strings    ${value}    ${result}
    Push Button    applyButton

    Select Dialog    Preferences
    ${value}=    Get Table Cell Value    0    ${row}    2
    Should Be Equal As Strings    ${value}    ${result}
    Close Dialog    Preferences

Check Skip
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver != '5'}}
