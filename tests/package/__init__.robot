*** Settings ***
Resource        ../../files/keywords.resource

Suite Setup     Suite Setup


*** Keywords ***
Suite Setup
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
