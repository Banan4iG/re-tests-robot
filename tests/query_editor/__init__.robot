*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Suite Teardown    Suite Teardown


*** Keywords ***
Curent Suite Teardown
    System Exit    0
    Clear History Files