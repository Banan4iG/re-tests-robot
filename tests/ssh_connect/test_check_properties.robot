*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***
test_ssh_conn
    Push Button    testButton
    Select Dialog    Message
    Label Text Should Be    0    The connection test was successful!
    Select Main Window
    Push Button    connectButton
    
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Disconect
    
    # backup
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Create database backup
    ${bk_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Select Tab    Backup
    Clear Text Field     backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

    # execute query
    Click On Tree Node    0    New Connection (Copy)    2
    Clear Text Field    0
    Type Into Text Field    0    select cast(:test as integer) from rdb$database
    Push Button    execute-script-command
    Select Dialog    Input parameters
    Type Into Text Field    0    1234
    Push Button     OK
    Select Main Window
    Clear Text Field    0

    # export metadata
    Push Button    extract-metadata-command
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    
    # # database statistics
    # Select From Main Menu    Tools|Database Statistics
    # Push Button    getStatButton
    
    # # trace manager 
    # Select From Main Menu    Tools|Trace Manager
    # Sleep    2s

    # user manager
    Select From Main Menu    Tools|User Manager
    ${values}=    Get Table Cell Value    usersTable    0    User name
    Should Be Equal As Strings      ${values}    SYSDBA

    # grant manager
    Select From Main Menu    Tools|Grant Manager
    Sleep    1s
    @{privileges_for_list}=    Get List Values    0
    @{expected_privileges_for_list}=    Create List    SYSDBA
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}
    
    # profiler
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Push Button    finishButton
    
    # table validator
    Select From Main Menu    Tools|Table Validator
    Push Button    selectAllButton
    Push Button    Start
    ${text}=    Get Text Field Value    0
    Should Not Be Empty    ${text}

    # import data
    Select From Main Menu    Tools|Import Data
    Check Check Box    importFromConnectionCheck
    Select From Combo Box    sourceTableCombo    COUNTRY
    Select From Combo Box    targetTableCombo    TEST_TABLE
    Push Button    correlateButton
    Push Button    startImportButton
    Close Dialog    Message  

    # data generator
    Select From Main Menu    Tools|Data Generator
    Select From Combo Box    tablesCombo    TEST_TABLE
    Click On Table Cell    0    0    0
    Click On Table Cell    0    1    0
    Push Button    startButton
    Sleep    0.5s
    Close Dialog    Message

    # remove conn
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Tree Node Popup Menu    0    New Connection    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Select Main Window

*** Keywords ***
Setup
    Lock Employee
    Execute Immediate    CREATE TABLE TEST_TABLE (COUNTRY VARCHAR, CURRENCY VARCHAR)
    Setup before every tests
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Connection information
    Check Check Box    useSshCheck
    Clear Text Field    sshHostField
    Type Into Text Field    sshHostField    localhost
    
    Clear Text Field    sshPortField
    Type Into Text Field    sshPortField    22
    
    ${ssh_info}=    Get User For Ssh
    ${user}=     Set Variable    ${ssh_info}[0]
    ${password}=    Set Variable    ${ssh_info}[1]

    Clear Text Field    sshUserField
    Type Into Text Field    sshUserField    ${user}
    
    Clear Text Field    sshPasswordField
    Type Into Text Field    sshPasswordField    ${password}
