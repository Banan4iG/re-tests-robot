*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Init Grant Manager
    Setup Before Every Tests
    Open Connection
    Select From Menu    Tools|Grant Manager
    Sleep    1s
