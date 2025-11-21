*** Settings ***
Resource    ../../files/keywords.resource
Suite Setup    Suite Setup

*** Keywords ***
Suite Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{not($ver == '5' and $srv_ver == 'RedDatabase')}}