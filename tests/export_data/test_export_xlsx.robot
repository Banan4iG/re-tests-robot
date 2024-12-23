*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_without
    Setup before export data
    ${export_path}=    Init XLSX

    ${expected_content}=    Catenate    SEPARATOR=\n    None\tNone\tNone\tNone\t    Carol\tNordstrom\t420.0\t1991-10-02T00:00\t    Luke\tLeung\t3.0\t1992-02-18T00:00\t    Sue Anne\tO''Brien\t877.0\t1992-03-23T00:00\t    Jennifer M.\tBurbank\t289.0\t1992-04-15T00:00\t    Claudia\tSutherland\t\t1992-04-20T00:00\t    Dana\tBishop\t290.0\t1992-06-01T00:00\t    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_include_column_name
    Setup before export data
    ${export_path}=    Init XLSX
    Check Check Box    addColumnHeadersCheck

    ${expected_content}=    Catenate    SEPARATOR=\n    FIRST_NAME\tLAST_NAME\tPHONE_EXT\tHIRE_DATE\t    Carol\tNordstrom\t420.0\t1991-10-02T00:00\t    Luke\tLeung\t3.0\t1992-02-18T00:00\t    Sue Anne\tO''Brien\t877.0\t1992-03-23T00:00\t    Jennifer M.\tBurbank\t289.0\t1992-04-15T00:00\t    Claudia\tSutherland\t\t1992-04-20T00:00\t    Dana\tBishop\t290.0\t1992-06-01T00:00\t    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_replace_null
    Setup before export data
    ${export_path}=    Init XLSX
    Check Check Box    replaceNullCheck
    Clear Text Field    replaceNullField
    Type Into Text Field    replaceNullField    LLUN
    Push Button    exportButton

    ${expected_content}=    Catenate    SEPARATOR=\n    None\tNone\tNone\tNone\t    Carol\tNordstrom\t420.0\t1991-10-02T00:00\t    Luke\tLeung\t3.0\t1992-02-18T00:00\t    Sue Anne\tO''Brien\t877.0\t1992-03-23T00:00\t    Jennifer M.\tBurbank\t289.0\t1992-04-15T00:00\t    Claudia\tSutherland\tLLUN\t1992-04-20T00:00\t    Dana\tBishop\t290.0\t1992-06-01T00:00\t    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_execute_to_file
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s  
    Select Dialog    Export Data
    ${export_path}=    Init XLSX
    Check Check Box    addColumnHeadersCheck
    ${expected_content}=    Catenate    SEPARATOR=\n    COUNTRY\tCURRENCY\t    USA\tDollar\t    England\tPound\t    Canada\tCdnDlr\t    Switzerland\tSFranc\t    Japan\tYen\t    Italy\tEuro\t    France\tEuro\t    Germany\tEuro\t    Australia\tADollar\t    Hong Kong\tHKDollar\t    Netherlands\tEuro\t    Belgium\tEuro\t    Austria\tEuro\t    Fiji\tFDollar\t    Russia\tRuble\t    Romania\tRLeu\t    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_max_row
    Lock Employee
    Add Rows
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM TEST_TABLE
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s  
    Select Dialog    Export Data
    ${export_path}=    Init XLSX
    Push Button    exportButton
    Sleep    10s
    Select Dialog    Warning
    Label Text Should Be    0    The maximum number of rows that can be exported is 1048575
    Push Button    OK
    Sleep    5s
    File Should Exist    ${export_path}
    File Should Not Be Empty    ${export_path}

*** Keywords ***
Init XLSX
    Select From Combo Box    typeCombo    XLSX
    ${export_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /export.xlsx
    Remove Files    ${export_path}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Uncheck All Checkboxes
    RETURN    ${export_path}

Check content
    [Arguments]   ${export_path}    ${expected_content}
    Push Button    exportButton
    Sleep    2s
    File Should Exist    ${export_path}
    ${content}=    Check Xlsx    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}