*** Settings ***
Resource    ../files/keywords.resource
Suite Teardown    Kill Rdbexpert
Test Timeout    60s
Suite Setup    Remove Driver


*** Keywords ***
Remove Driver
    ${path_to_exe}=    Get Path
    # Log    ${path_to_exe}    console=True
    TRY
        Start Application    rdb_expert    ${path_to_exe}    timeout=20    remote_port=60900
        # Start Application    rdb_expert     java -javaagent:D:/re-tests-robot/lib/jacocoagent.jar=destfile=D:/re-tests-robot/results/jacoco.exec,output=file -jar D:/projects/RDBExpert/rdbexpert.jar -exe_path=D:/projects/RDBExpert/bin/RDBExpert.exe    timeout=20
    EXCEPT    RemoteSwingLibraryTimeoutError: Agent port not received before timeout
        Log    RDBExpert failed to launch    console=True
        Kill Rdbexpert
    END
    Select Main Window
    Select From Main Menu    System|Drivers
    ${row}=    Find Table Row    driversTable    RedDatabase JDBC Driver 5   Driver Name
    Click On Table Cell    driversTable     ${row}    Driver Name
    Push Button    removeDriverButton
    Select Dialog    Confirmation
    Push Button    Yes
    Select Main Window
    System Exit    0
    Clear History Files
