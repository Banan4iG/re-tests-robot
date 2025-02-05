*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY
    Push Button    execute-script-command
    Sleep    1s  
    Select From Table Cell Popup Menu    0    0    0   Export|Table
    Select Dialog    Export Data
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /export.csv
    Remove Files    ${export_path}
    Select From Combo Box    columnDelimiterCombo    ;
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Uncheck All Checkboxes
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    IF    ${{$ver == '2.6'}}
        ${expected_content}=    Catenate    SEPARATOR=\n    COUNTRY;CURRENCY    USA;Dollar    England;Pound    Canada;CdnDlr    Switzerland;SFranc    Japan;Yen    Italy;Lira    France;FFranc    Germany;D-Mark    Australia;ADollar    Hong Kong;HKDollar    Netherlands;Guilder    Belgium;BFranc    Austria;Schilling    Fiji;FDollar    ${EMPTY}
    ELSE
        ${expected_content}=    Catenate    SEPARATOR=\n    COUNTRY;CURRENCY    USA;Dollar    England;Pound    Canada;CdnDlr    Switzerland;SFranc    Japan;Yen    Italy;Euro    France;Euro    Germany;Euro    Australia;ADollar    Hong Kong;HKDollar    Netherlands;Euro    Belgium;Euro    Austria;Euro    Fiji;FDollar    Russia;Ruble    Romania;RLeu    ${EMPTY}
    END
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}

    