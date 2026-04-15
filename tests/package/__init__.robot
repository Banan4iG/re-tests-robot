*** Settings ***
Resource        ../../files/keywords.resource

Suite Setup     Suite Setup


*** Keywords ***
Suite Setup
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
