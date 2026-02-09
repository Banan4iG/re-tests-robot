*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Local Setup
    ${info}=    Get Server Info
    ${ver}=    Set Variable    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Test Setup
