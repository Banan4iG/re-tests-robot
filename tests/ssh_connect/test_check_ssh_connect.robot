*** Settings ***
Library             RemoteSwingLibrary
Library             platform
Resource            ../../files/keywords.resource

Suite Setup         Setup
Suite Teardown      Teardown
Test Setup          Test Setup
Test Teardown       Local Test Teardown


*** Test Cases ***
test_backup
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Backup/Restore Database
    ${bk_path}=    Catenate    SEPARATOR=${EMPTY}    ${TEMPDIR}    /employee_backup.fbk
    Remove File    ${bk_path}
    Select Tab As Context    Database backup/restore
    Select Tab    Backup
    Clear Text Field    backupFileField
    Type Into Text Field    backupFileField    ${bk_path}

    Push Button    backupButton
    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    0    Backup completed successfully!
    Push Button    OK

test_execute_query
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Query Editor
    Select Main Window
    Clear Text Field    0
    Type Into Text Field    0    select cast(:test as integer) from rdb$database
    Push Button    execute-script-command
    Select Dialog    Input parameters
    Type Into Text Field    0    1234
    Push Button    OK
    Select Main Window
    Clear Text Field    0

test_export_metadata
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Extract Metadata
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message

test_database_statistics
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Database Statistic
    Push Button    getStatButton
    ${text}=    Get Text Field Value    0
    Should Not Be Empty    ${text}

test_trace_manager
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Trace Manager
    Sleep    5s
    Select Tab As Context    Trace Manager
    Push Button    startStopSessionButton
    Sleep    10s
    Select Tab    Session Manager
    Push Button    startStopSessionButton
    Select Main Window

test_user_manager
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|User Manager
    Sleep    1s
    ${values}=    Get Table Cell Value    usersTable    0    User name
    Should Be Equal As Strings    ${values}    SYSDBA

test_grant_manager
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Grant Manager
    Sleep    1s
    @{privileges_for_list}=    Get List Values    0
    VAR    @{expected_privileges_for_list}=    SYSDBA
    Should Be Equal As Strings    ${privileges_for_list}    ${expected_privileges_for_list}

test_profiler
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    Skip If    ${{$ver != '5'}}
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Profiler
    Push Button    startButton
    Sleep    2s
    Push Button    finishButton
    Close Dialog    Warning

test_table_validator
    Lock Employee
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Table Validator
    ${count}=    Get List Item Count    0
    Should Be Equal As Integers    ${count}    10

test_import_data
    Lock Employee
    Execute Immediate    CREATE TABLE TEST_TABLE (COUNTRY VARCHAR(1024), CURRENCY VARCHAR(1024))
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Import Data
    Check Check Box    importFromConnectionCheck
    Select From Combo Box    sourceTableCombo    COUNTRY
    Select From Combo Box    targetTableCombo    TEST_TABLE
    Push Button    correlateButton
    Push Button    startImportButton
    Close Dialog    Message

test_data_generator
    Lock Employee
    Execute Immediate    CREATE TABLE TEST_TABLE (COUNTRY VARCHAR(1024), CURRENCY VARCHAR(1024))
    Click On Tree Node    0    New Connection (Copy)    2
    Select From Main Menu    Tools|Data Generator
    Select From Combo Box    tablesCombo    TEST_TABLE
    Click On Table Cell    0    0    0
    Click On Table Cell    0    1    0
    Push Button    startButton
    Sleep    0.5s
    Close Dialog    Message


*** Keywords ***
Setup
    # ${system}=    platform.System
    # Skip If    '${system}' == 'Linux'
    Test Setup
    Select From Tree Node Popup Menu    0    New Connection    Duplicate connection
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Connection properties
    Check Check Box    useSshCheck
    Clear Text Field    sshHostField
    Type Into Text Field    sshHostField    localhost

    Clear Text Field    sshPortField
    Type Into Text Field    sshPortField    22

    ${ssh_info}=    Get User For Ssh
    VAR    ${user}=    ${ssh_info}[0]
    VAR    ${password}=    ${ssh_info}[1]

    Clear Text Field    sshUserField
    Type Into Text Field    sshUserField    ${user}
    Clear Text Field    10
    Type Into Text Field    10    ${password}

    Select From Combo Box    charsetsCombo    UTF8
    Push Button    saveButton
    Push Button    testButton
    Sleep    2s
    TRY
        Select Dialog    Message
    EXCEPT    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Message'
        VAR    ${file_name}=    ${{$SUITE_NAME.replace(' ', '_')}}
        Take Screenshot    ${file_name}    1080
    END
    Label Text Should Be    0    The connection test was successful!
    Push Button    OK
    Select Main Window

Local Test Teardown
    Select Main Window
    Close All Tabs
    Select From Tree Node Popup Menu    0    New Connection (Copy)    Disconnect
    Test Teardown

Teardown
    Select Main Window
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection (Copy)    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
