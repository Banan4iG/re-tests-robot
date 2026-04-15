*** Settings ***
Library             platform
Library             RemoteSwingLibrary
Resource            ../../files/keywords.resource

Test Setup          Test Setup
Test Teardown       Test Teardown


*** Test Cases ***
test_check_no_ignore
    Init Extract
    ${script_without_properties}=    Extract
    Log Variables
    @{result}=    Check Ignore    ${script_without_properties}
    # Delete Objects    ${rdb5}
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    IF    '${ver}' == '2.6'
        Should Be Equal As Strings    ${result}    [12, 3, 10, 14, 3, 23]
    ELSE
        Should Be Equal As Strings    ${result}    [15, 3, 10, 14, 3, 23]
    END

test_check_ignore
    Init Extract
    Push Button    selectAllExtractPropertiesButton
    ${script_without_properties}=    Extract
    @{result}=    Check Ignore    ${script_without_properties}
    # Delete Objects    ${rdb5}
    Should Be Equal As Strings    ${result}    [0, 0, 0, 0, 1, 9]

test_check_ignore_whitespace
    ${info}=    Get Server Info
    VAR    ${home_dir}=    ${info}[0]
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    VAR    ${employee_path}=    ${home_dir}examples/empbuild/employee.fdb
    VAR    ${original_employee_path}=    ${home_dir}original_employee.fdb
    VAR    ${copy_employee_path}=    ${home_dir}copy_employee.fdb
    Remove Files    ${original_employee_path}    ${copy_employee_path}
    Copy File    ${employee_path}    ${original_employee_path}

    IF    ${{$ver != '2.6'}}
        Execute Immediate    CREATE OR ALTER FUNCTION NEW_FUNC RETURNS BIGINT AS BEGIN /* Function impl */ END
        VAR    ${obj_count}=    3
        IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
            ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
            IF    ${{$connect_type == 'embedded'}}
                VAR    ${expected_tree}=
                ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions (1)', 'Packages', 'Table Triggers (1)', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices', 'Tablespaces', 'Collations']
            ELSE
                VAR    ${expected_tree}=
                ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions (1)', 'Packages', 'Table Triggers (1)', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices', 'Tablespaces', 'Jobs', 'Collations']
            END
        ELSE
            VAR    ${expected_tree}=
            ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Functions (1)', 'Packages', 'Table Triggers (1)', 'DDL Triggers', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices', 'Collations']
        END
    ELSE
        VAR    ${obj_count}=    2
        VAR    ${expected_tree}=
        ...    ['Domains', 'Tables', 'Global Temporary Tables', 'Views', 'Procedures (1)', 'Table Triggers (1)', 'DB Triggers', 'Sequences', 'Exceptions', 'UDFs', 'Roles', 'Indices', 'Collations']
    END

    Copy File    ${employee_path}    ${copy_employee_path}

    ${system}=    platform.System
    IF    ${{$system == 'Linux'}}
        IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
            Change Owner    ${copy_employee_path}    reddatabase
        ELSE
            Change Owner    ${copy_employee_path}    firebird
        END
    END

    Alter Copy    ${copy_employee_path}

    Push Button    new-connection-command
    Sleep    1s
    IF    ${{$ver == '2.6'}}
        Select From Combo Box    serverCombo    Red Database (Firebird) 2.X
        Select From Combo Box    authCombo    Basic
    END
    Type Into Combobox    hostCombo    localhost
    Type Into Text Field    portField    3050
    Type Into Text Field    fileField    ${copy_employee_path}
    Type Into Text Field    userField    sysdba
    Type Into Text Field    passwordField    masterkey
    Check Check Box    Store Password
    ${connect_type}=    Get Environment Variable    CONNECT_TYPE    server
    IF    ${{$connect_type == 'embedded'}}
        Check Check Box    useEmbeddedCheck
    END
    Push Button    saveButton

    Click On Tree Node    0    New Connection
    Push Button    comparerDB-command
    Select Tab As Context    Comparer DB

    Select From Combo Box    dbMasterComboBox    New Connection 1
    Push Button    selectAllAttributesButton

    Chech Objects Count    obj_count=${obj_count}

    Select Main Window
    Select Tab As Context    Comparer DB
    Select Tab As Context    View
    Select Main Window

    ${node_names}=    Get Tree Node Child Names    dbComponentsTree    Objects To Alter
    Should Be Equal As Strings    ${node_names}    ${expected_tree}

    Select Main Window
    Check Check Box    ignoreWhitespaces

    Chech Objects Count    obj_count=0

    [Teardown]    Local Teardown    original_employee_path=${original_employee_path}    employee_path=${employee_path}


*** Keywords ***
Init Extract
    Lock Employee
    Create Objects
    Push Button    extract-metadata-command

Extract
    Push Button    extractButton
    Sleep    5s
    Close Dialog    Message
    Select Tab As Context    DB Metadata Export
    Select Tab As Context    SQL
    ${script}=    Get Text Field Value    0
    RETURN    ${script}

Check Ignore
    [Arguments]    ${script}
    VAR    @{result}=
    ...    ${{$script.count("COMMENT ON")}}
    ...    ${{$script.count("COMPUTED BY")}}
    ...    ${{$script.count("PRIMARY KEY")}}
    ...    ${{$script.count("FOREIGN KEY")}}
    ...    ${{$script.count("UNIQUE")}}
    ...    ${{$script.count("CHECK (")}}
    RETURN    @{result}

Chech Objects Count
    [Arguments]    ${obj_count}
    Push Button    compareButton

    Sleep    2s
    Select Dialog    Message
    Label Text Should Be    1    Objects to create - 0
    Label Text Should Be    2    Objects to alter - ${obj_count}
    Label Text Should Be    3    Objects to drop - 0
    Sleep    2s
    Push Button    OK
    Select Main Window

Local Teardown
    [Arguments]    ${original_employee_path}    ${employee_path}
    Select Main Window
    Close All Tabs
    Select From Tree Node Popup Menu    0    New Connection 1    Disconnect
    Select From Tree Node Popup Menu In Separate Thread    0    New Connection 1    Delete connection
    Select Dialog    Delete connection
    Push Button    Yes
    Test Teardown
    Sleep    2s
    Move File    ${original_employee_path}    ${employee_path}

    ${system}=    platform.System
    ${info}=    Get Server Info
    VAR    ${ver}=    ${info}[1]
    VAR    ${srv_ver}=    ${info}[2]
    IF    ${{$system == 'Linux'}}
        IF    ${{$ver == '5' and $srv_ver == 'RedDatabase'}}
            Change Owner    ${employee_path}    reddatabase
        ELSE
            Change Owner    ${employee_path}    firebird
        END
    END
