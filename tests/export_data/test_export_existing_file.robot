*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource
Resource            key.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_overwrite_yes
    ${export_path}=    Init
    File Should Exist    ${export_path}
    ${content1}=    Get File    ${export_path}

    Init Double    ${export_path}
    Push Button    Yes
    Sleep    5s
    Close Dialog    Message
    File Should Exist    ${export_path}
    ${content2}=    Get File    ${export_path}
    Should Not Be Equal As Strings    ${content1}    ${content2}

test_overwrite_no
    ${export_path}=    Init
    File Should Exist    ${export_path}
    ${content1}=    Get File    ${export_path}

    Init Double    ${export_path}
    Push Button    No

    Close Dialog    Export Data
    File Should Exist    ${export_path}
    ${content2}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content1}    ${content2}

test_overwrite_close
    ${export_path}=    Init
    File Should Exist    ${export_path}
    ${content1}=    Get File    ${export_path}

    Init Double    ${export_path}
    Close Dialog    Confirmation

    Close Dialog    Export Data
    File Should Exist    ${export_path}
    ${content2}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content1}    ${content2}


*** Keywords ***
Init
    Setup Before Export Data
    Select From Combo Box    typeCombo    CSV
    ${export_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /export.csv
    Remove Files    ${export_path}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    RETURN    ${export_path}

Init Double
    [Arguments]    ${export_path}
    Select Main Window
    Select Tab As Context    regexp=^Query Editor.*
    Select Tab As Context    Result Set 1
    Select From Table Cell Popup Menu    0    0    0    Export|All data
    Select Dialog    Export Data
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Push Button    exportButton
    Select Dialog    Confirmation
