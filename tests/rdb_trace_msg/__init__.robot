*** Settings ***
Resource            ../../files/keywords.resource
Library             RemoteSwingLibrary

Suite Setup         Local Suite Setup


*** Keywords ***
Local Suite Setup
    Skip If Embedded
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}
