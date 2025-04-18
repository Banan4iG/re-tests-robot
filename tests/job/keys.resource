*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource

*** Keywords ***
Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5.0' and $srv_ver == 'RedDatabase')}}
    Test Setup

Local Test Teardown
    Select Dialog    Commiting changes
    Push Button    rollbackButton

    Select Dialog    Create job
    Push Button    cancelButton

    Select Dialog    Confirmation
    Push Button    Yes
    
    Select Main Window
    Test Teardown