*** Settings ***
Resource            ../../files/keywords.resource
Library             RemoteSwingLibrary

Suite Setup         Local Suite Setup


*** Keywords ***
Local Suite Setup
    Skip If Embedded
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
