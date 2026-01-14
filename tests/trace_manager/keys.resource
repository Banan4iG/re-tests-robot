*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Teardown
    Teardown After Every Tests
    Restore Audit Profiles
