*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    help_func.py


*** Keywords ***
Setup before every tests
    ${path_to_exe}=    Get Path
    Log    ${path_to_exe}    console=True
    Start Application    red_expert    ${path_to_exe}    timeout=20
    Select Window    regexp=^Red.*

Teardown after every tests
    System Exit
    Clear History Files        

Open connection
    Click On Tree Node    0    New Connection    2
