*** Settings ***
Resource            ../../files/keywords.resource
Library             RemoteSwingLibrary


*** Keywords ***
Local Teardown
    Select Dialog    Commiting changes
    Push Button    rollbackButton
    Select Dialog    Create job
    Push Button    cancelButton

    Select Dialog    Confirmation
    Push Button    Yes

    Select Main Window
    Test Teardown
