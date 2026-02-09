*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Init Grant Manager
    Test Setup
    Open Connection
    Select From Menu    Tools|Grant Manager
    Sleep    1s
