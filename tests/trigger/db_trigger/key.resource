*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../../files/keywords.resource

*** Keywords ***
Local Test Teardown
    System Exit    0
    Unlock Employee
    Clear History Files