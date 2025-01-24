*** Settings ***
Library    RemoteSwingLibrary
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_check_no_ignore
    ${rdb5}=    Init extract
    ${script_without_properties}=    Extract
    @{result}=    Check Ignore    ${script_without_properties}
    # Delete Objects    ${rdb5}
    Should Be Equal As Strings    ${result}    [15, 1, 1, 1, 1, 1]

test_check_ignore
    ${rdb5}=    Init extract
    Push Button    selectAllExtractPropertiesButton
    ${script_without_properties}=    Extract
    @{result}=    Check Ignore    ${script_without_properties}
    # Delete Objects    ${rdb5}
    Should Be Equal As Strings    ${result}    [0, 0, 0, 0, 0, 0]


*** Keywords ***
Init extract
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    VAR    ${rdb5}    ${{$ver == '5.0'}}
    Lock Employee
    Create Objects    ${rdb5}
    Push Button    extract-metadata-command
    RETURN    ${rdb5}

Extract
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    SQL
    ${script}=    Get Text Field Value    0
    RETURN    ${script}
    
Check Ignore
    [Arguments]    ${script}
    @{result}    Create List    ${{$script.count("COMMENT ON")}}    ${{$script.count("COMPUTED FIELDs defining")}}    ${{$script.count("PRIMARY KEYs defining")}}    ${{$script.count("FOREIGN KEYs defining")}}    ${{$script.count("UNIQUE KEYs defining")}}    ${{$script.count("CHECK KEYs defining")}}
    RETURN    @{result}