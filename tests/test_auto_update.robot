*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Teardown    Teardown

*** Test Cases ***
old_api_no_reload
    Skip    No support
    ${path_to_exe}=    Test Api    \nupdate.use.https=false\nreddatabase.check.rc.url=http\://localhost\nreddatabase.check.url=http\://localhost\nreddatabase.get-files.url=http\://localhost/?project\=redexpert&version\=    ${False}
    No Reload    ${path_to_exe}

old_api_auto_reload
    Skip    No support
    ${path_to_exe}=    Test Api    \nupdate.use.https=false\nreddatabase.check.rc.url=http\://localhost\nreddatabase.check.url=http\://localhost\nreddatabase.get-files.url=http\://localhost/?project\=redexpert&version\=    ${False}

new_api_no_reload
    ${path_to_exe}=    Test Api    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert\nupdate.check.rc.url=http\://localhost/?project=redexpert&showrc=true    ${True}
    No Reload    ${path_to_exe}

new_api_auto_reload
    Skip    Not working yet
    ${path_to_exe}=    Test Api    \nupdate.use.https=false\nupdate.check.url=http\://localhost/?project=redexpert\nupdate.check.rc.url=http\://localhost/?project=redexpert&showrc=true    ${True}
    Auto Reload

*** Keywords ***
Start Red Expert
    [Arguments]    ${path_to_exe}
    Log    ${path_to_exe}    console=True
    Start Application    red_expert    ${path_to_exe}    timeout=20    remote_port=60900    

Stop Red Expert
    System Exit    0

Teardown
    Stop Server
    Teardown after every tests
    Restore User Properties

Test Api
    [Arguments]    ${urls}    ${new}
    Run Server
    Backup User Properties
    Set Urls   urls=${urls}
    ${path_to_exe}=    Copy Dist Path
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red.*
    Select From Menu    Help|Check for Update
    Sleep       5s
    Select Dialog    RedExpert Update
    IF    ${new}
        Push Button      Yes
        Close Dialog    Latest Version Info
    ELSE
        Push Button      No
    END
    Sleep    1s
    Select Dialog    RedExpert Update
    Push Button      Yes
    Sleep       10s    
    Select Dialog    Update downloaded
    Copy Updater
    RETURN   ${path_to_exe}

Copy Updater   
    ${dist}=    Get Environment Variable    DIST    C:/Program Files/RedExpert
    Copy File    ${dist}${/}Updater.jar    ${TEMPDIR}${/}RedExpert${/}Updater.jar

No Reload
    [Arguments]    ${path_to_exe}
    Push Button      No
    Select Dialog    Message
    Push Button      OK
    System Exit    0
    Sleep       10s
    Start Red Expert    ${path_to_exe}
    Select Window    regexp=^Red Expert - 2025\.03.*

Auto Reload
    Push Button      Yes
    Sleep       10s
    Application Started    red_expert    timeout=20    remote_port=60900
    Select Window    regexp=^Red Expert - 2025\.03.*
