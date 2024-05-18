*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Resource    ../files/keywords.resource
Suite Setup    Setup All Tests
Suite Teardown    Teardown all tests

*** Test Cases ***
first
    Open connection
    Click On Tree Node    0    New Connection    2
    