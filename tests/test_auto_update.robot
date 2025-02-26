*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Resource    ../files/keywords.resource
Test Teardown    Teardown

*** Test Cases ***
old_api
    Run Server
    Backup User Properties
    Set Urls    urls=\nupdate.use.https=false \n reddatabase.check.rc.url=http\://localhost\nreddatabase.check.url=http\://localhost\nreddatabase.get-files.url=http\://localhost/?project\=redexpert&version\=    
    ${path_to_exe}=    Copy Dist Path
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red.*
    Select From Menu    Help|Check for Update
    Sleep       5s
    Select Dialog    RedExpert Update
    Push Button      No
    Sleep    1s
    Select Dialog    RedExpert Update
    Push Button      Yes
    Sleep       10s    
    Select Dialog    Update downloaded
    Push Button      No
    Select Dialog    Message
    Push Button      OK
    System Exit    0
    Sleep       10s
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red Expert - 2023\.10.*

new_api
    Run Server
    Backup User Properties
    Set Urls   urls=\nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert\nupdate.check.rc.url=http\://localhost/?project=redexpert&showrc=true
    ${path_to_exe}=    Copy Dist Path
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red.*
    Select From Menu    Help|Check for Update
    Sleep       5s
    Select Dialog    RedExpert Update
    Push Button      Yes
    Close Dialog    Latest Version Info
    Sleep    1s
    Select Dialog    RedExpert Update
    Push Button      Yes
    Sleep       10s    
    Select Dialog    Update downloaded
    Push Button      No
    Select Dialog    Message
    Push Button      OK
    System Exit    0
    Sleep       10s
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^RDB Expert - 2025\.02.*

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