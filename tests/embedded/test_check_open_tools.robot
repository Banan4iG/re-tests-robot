*** Settings ***
Library    RemoteSwingLibrary
Resource    ../../files/keywords.resource
# Suite Setup    Suite Setup
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_open
    Open connection
    Select From Main Menu    Database|Database Backup/Restore
    Check Warning

    Select From Main Menu    Database|Convert Database
    Check Warning

    Select From Main Menu    Tools|Database Statistic
    Check Warning

    Select From Main Menu    Tools|Trace Manager
    Check Warning

    Select From Main Menu    Tools|User Manager
    Check Warning

    Select From Main Menu    Tools|Grant Manager
    Check Warning

    Select From Main Menu    Tools|Table Validator
    Check Warning

*** Keywords ***
Suite Setup
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    Skip If    ${{$connect_type != 'embedded'}}

Check Warning
    Select Dialog    Warning
    Label Text Should Be    0    There are no connections supported by the selected tool
    Label Text Should Be    1    (the tool does not support embedded connections).
    Push Button    OK
    Select Main Window
