*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Suite Setup    Curent Suite Setup
# Suite Teardown    Suite Teardown


*** Keywords ***
# Curent Suite Teardown
#     System Exit    0
#     Clear History Files
Curent Suite Setup
    Test Setup
    Select From Main Menu    System|Drivers