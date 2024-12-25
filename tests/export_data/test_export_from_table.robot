*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_export_selection
    Open connection
    Click On Tree Node    0    New Connection|Tables (10)|EMPLOYEE    2
    Sleep    1s
    Select Tab As Context    Data
    Select Table Cell Area    0    1    4    19    24    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    Select Dialog    Export Data

    ${row_name}=    Find Table Row    0    FIRST_NAME
    ${row_phone}=    Find Table Row    0    PHONE_EXT

    Click On Table Cell    0    ${row_name}    1
    Click On Table Cell    0    ${row_name}    0

    Click On Table Cell    0    ${row_phone}    1
    Click On Table Cell    0    ${row_phone}    0
    
    ${expected_content}=    Catenate    SEPARATOR=\n    Nordstrom;1991-10-02T00:00    Leung;1992-02-18T00:00    O''Brien;1992-03-23T00:00    Burbank;1992-04-15T00:00    Sutherland;1992-04-20T00:00    Bishop;1992-06-01T00:00    ${EMPTY}
    Check    ${expected_content}

test_export_table
    Open connection
    Click On Tree Node    0    New Connection|Tables (10)|COUNTRY    2
    Sleep    1s
    Select Tab As Context    Data
    Select From Table Cell Popup Menu    0    0    0   Export|Table

    Select Dialog    Export Data
    
    ${expected_content}=    Catenate    SEPARATOR=\n    USA;Dollar    England;Pound    Canada;CdnDlr    Switzerland;SFranc    Japan;Yen    Italy;Euro    France;Euro    Germany;Euro    Australia;ADollar    Hong Kong;HKDollar    Netherlands;Euro    Belgium;Euro    Austria;Euro    Fiji;FDollar    Russia;Ruble    Romania;RLeu    ${EMPTY}
    Check   ${expected_content}

*** Keywords ***
Check
    [Arguments]   ${expected_content}
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /export.csv
    Remove Files    ${export_path}
    Select Tab  Options
    Select From Combo Box    columnDelimiterCombo    ;
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Uncheck All Checkboxes
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}