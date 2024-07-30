*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Resource    ../files/keywords.resource
Test Teardown    Teardown

*** Test Cases ***
first
    Run Server
    Bakup User Properties
    Set Urls
    ${path_to_exe}=    Copy Dist Path
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red.*
    Select From Menu    Help|Check for Update
    Sleep       5s
    Select Dialog    RedExpert Update
    Push Button      Yes
    Sleep       10s    
    Select Dialog    Update downloaded
    Push Button      No
    Select Dialog    Message
    Push Button      OK
    System Exit
    Sleep       10s
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red Expert - 2023\.10.*
    
*** Keywords ***
Start Red Expert
    [Arguments]    ${path_to_exe}
    Log    ${path_to_exe}    console=True
    Start Application    red_expert    ${path_to_exe}    timeout=20    

Stop Red Expert
    System Exit    0

Teardown
    Stop Server
    Teardown after every tests
    Restore User Properties