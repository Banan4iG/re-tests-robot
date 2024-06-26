*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    help_func.py


*** Keywords ***
Setup before every tests
    ${path_to_exe}=    Get Path
    Start Application    red_expert    ${path_to_exe}    timeout=10
    Select Window    regexp=^Red.*

Teardown after every tests
    Clear History Files
    System Exit    

Open connection
    Click On Tree Node    0    New Connection    2
