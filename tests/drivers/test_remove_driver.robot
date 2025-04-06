*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***
test_1
    Push Button    addDriverButton
    Select Dialog    Add New Driver
    Push Button    Save
    Select Main Window
    ${row}=    Find Table Row    driversTable    New Driver   Driver Name
    Click On Table Cell    driversTable     ${row}    Driver Name
    Push Button    removeDriverButton
    Select Dialog    Confirmation
    Push Button    No
    Select Main Window
    ${row}=    Find Table Row    driversTable    New Driver   Driver Name
    Should Not Be Equal As Integers    ${row}    -1 
    Push Button    removeDriverButton
    Select Dialog    Confirmation
    Push Button    Yes
