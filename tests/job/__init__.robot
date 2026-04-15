*** Settings ***
Resource            ../../files/keywords.resource
Library             RemoteSwingLibrary

Suite Setup         Suite Setup
Test Teardown       Local Teardown


*** Keywords ***
Local Teardown
    Select Dialog    Commiting changes
    Push Button    rollbackButton
    Select Dialog    Create job
    Push Button    cancelButton

    Select Dialog    Confirmation
    Push Button    Yes

    Select Main Window
    Test Teardown

Suite Setup
    Skip If Embedded
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
