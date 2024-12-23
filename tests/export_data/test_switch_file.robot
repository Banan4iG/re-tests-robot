*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Setup before export data
    Select From Combo Box    typeCombo    CSV
    ${export_path_csv}=     Catenate    SEPARATOR=    ${TEMPDIR}    /export.csv
    ${export_path_xlsx}=    Catenate    SEPARATOR=    ${TEMPDIR}    /export.xlsx
    ${export_path_xml}=     Catenate    SEPARATOR=    ${TEMPDIR}    /export.xml
    ${export_path_sql}=     Catenate    SEPARATOR=    ${TEMPDIR}    /export.sql
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path_csv}

    Select From Combo Box    typeCombo    XLSX
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_xlsx}    collapse_spaces=${True}    strip_spaces=${True}

    Select From Combo Box    typeCombo    XML
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_xml}    collapse_spaces=${True}    strip_spaces=${True}

    Select From Combo Box    typeCombo    SQL
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_sql}    collapse_spaces=${True}    strip_spaces=${True}

    Select From Combo Box    typeCombo    CSV
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings    ${current_export_path}    ${export_path_csv}    collapse_spaces=${True}    strip_spaces=${True}
    