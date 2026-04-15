*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Setup
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver == '2.6'}}
    Test Setup
