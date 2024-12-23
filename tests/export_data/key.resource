*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Setup before export data
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM EMPLOYEE
    Push Button    execute-script-command
    Sleep    1s
    Select Table Cell Area    0    1    4    19    24    
    Select From Table Cell Popup Menu On Selected Cells    0    Export|Selection
    Select Dialog    Export Data