*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource
Resource            key.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_1
    Setup Before Export Data
    ${export_path_csv}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    ${/}export.csv
    ${export_path_xlsx}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    ${/}export.xlsx
    ${export_path_xml}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    ${/}export.xml
    ${export_path_sql}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    ${/}export.sql

    Select From Combo Box    typeCombo    CSV
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings
    Setup Before Export Datapath}
    ...    ${export_path_csv}
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}

    Select From Combo Box    typeCombo    XLSX
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings
    ...    ${current_export_path}
    ...    ${export_path_xlsx}
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}

    Select From Combo Box    typeCombo    XML
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings
    ...    ${current_export_path}
    ...    ${export_path_xml}
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}

    Select From Combo Box    typeCombo    SQL
    Select Export File Path
    ${current_export_path}=    Get Text Field Value    filePathField
    Should Be Equal As Strings
    ...    ${current_export_path}
    ...    ${export_path_sql}
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}

test_blob
    Open Connection
    Clear Text Field    0
    Insert Into Text Field    0    select * from PROJECT
    Push Button    execute-script-command
    Sleep    1s
    Select Table Cell Area    0    1    2    0    2
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selected data
    Select Dialog    Export Data
    Select From Combo Box    typeCombo    CSV

    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${TEMPDIR}/export.csv

    Push Button    browseFolderButton
    Select Dialog    Select Export File Path
    Clear Text Field    0
    Type Into Text Field    0    ${TEMPDIR}/export
    Push Button    Select
    Select Dialog    Export Data

    ${export_path_blob}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    ${/}export.lob
    ${current_export_path}=    Get Text Field Value    folderPathField
    Should Be Equal As Strings
    ...    ${current_export_path}
    ...    ${export_path_blob}
    ...    collapse_spaces=${True}
    ...    strip_spaces=${True}


*** Keywords ***
Select Export File Path
    Clear Text Field    filePathField
    Push Button    browseFileButton
    Select Dialog    Select Export File Path
    Clear Text Field    0
    Type Into Text Field    0    ${TEMPDIR}/export
    Push Button    Select
    Select Dialog    Export Data
