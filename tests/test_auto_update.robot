#The test is not working yet. See RS-186276.

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
    Start Red Expert
    Select From Menu    Help|Check for Update
    Sleep       5s
    Select Dialog    RedExpert Update
    Push Button      0
    Sleep       5s
    Select Dialog    Update downloaded
    Push Button      0 
    # Select Dialog    Message
    # Push Button      OK
    Sleep       60s
    Select Window    regexp=^Red Expert - 2023\.10.*
    
    
*** Keywords ***
Start Red Expert
    ${path_to_exe}=    Copy Dist Path
    Log    ${path_to_exe}    console=True
    Start Application    red_expert    ${path_to_exe}    timeout=20
    Select Window    regexp=^Red.*

Stop Red Expert
    System Exit    0

Teardown
    Stop Server
    Teardown after every tests
    Restore User Properties