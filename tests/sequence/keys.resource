*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource

*** Keywords ***
Setup
    ${info}=    Get Server Info
    ${ver}=     Set Variable    ${info}[1]
    ${srv_ver}=    Set Variable    ${info}[2]
    Skip If    ${{$ver == '2.6'}}
    Test Setup

Local Test Teardown
    System Exit    0
    Unlock Employee
    Clear History Files