*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Local Setup
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Test Setup
