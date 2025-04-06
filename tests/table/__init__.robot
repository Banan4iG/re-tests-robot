*** Settings ***
Library    RemoteSwingLibrary
Resource    ../files/keywords.resource
Test Teardown    Local Test Teardown

*** Keywords ***
Local Test Teardown
    System Exit    0
    Unlock Employee
    Clear History Files