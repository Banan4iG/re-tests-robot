*** Settings ***
Resource            ../../../files/keywords.resource
Suite Setup         Local Suite Teardown


*** Keywords ***
Local Suite Teardown
    Test Setup
    Select From Main Menu    System|Preferences
    Select Dialog    Preferences
    Push Button    restoreButton
    Push Button    OK
    Select Dialog    Message
    Push Button    OK
    Select Main Window
