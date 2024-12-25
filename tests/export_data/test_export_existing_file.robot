*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_overwrite_yes
    ${export_path}=    Init
    File Should Exist    ${export_path}
    ${content1}=    Get File    ${export_path}
    
    Init double
    Push Button    Yes
    Sleep    5s
    File Should Exist    ${export_path}
    ${content2}=    Get File    ${export_path}
    Should Not Be Equal As Strings    ${content1}    ${content2}

test_overwrite_no
    ${export_path}=    Init
    File Should Exist    ${export_path}
    ${content1}=    Get File    ${export_path}
    
    Init double
    Push Button    No
    
    File Should Exist    ${export_path}
    ${content2}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content1}    ${content2}

test_overwrite_close
    ${export_path}=    Init
    File Should Exist    ${export_path}
    ${content1}=    Get File    ${export_path}
    
    Init double
    Close Dialog    Confirmation
    
    File Should Exist    ${export_path}
    ${content2}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content1}    ${content2}
    
*** Keywords ***
Init
    Setup before export data
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    /export.csv
    Remove Files    ${export_path}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Push Button    exportButton 
    Sleep    5s
    Close Dialog    Message

    RETURN    ${export_path}

Init double
    Select Main Window
    Select From Table Cell Popup Menu    0    0    0   Export|Table
    Select Dialog    Export Data
    Push Button    exportButton
    Select Dialog    Confirmation