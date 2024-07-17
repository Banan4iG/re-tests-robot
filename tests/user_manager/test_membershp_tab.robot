*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource   ../../files/keywords.resource 
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_check_membership_role_to_user
    Action    USER    1


test_check_membership_role_to_role
    Action    ROLE    2



*** Keywords ***
Action
    [Arguments]    ${type}    ${row_number}
    IF    '${type}' == 'USER'
        Execute Immediate    CREATE USER TEST_USER PASSWORD 'pass'
    ELSE
        Execute Immediate    CREATE ROLE TEST_USER
    END
    Execute Immediate    CREATE ROLE ATEST_ROLE
    Open connection
    Select From Menu        Tools|User Manager
    IF    '${type}' == 'ROLE'
        Check Check Box    roleToRoleCheck
    END
    Sleep    1s

    Click On Table Cell    membershipTable    ${row_number}    0
    Push Button    grantRoleButton
    ${result1}=    Check membership
    
    Click On Table Cell    membershipTable    ${row_number}    0
    Push Button    grandAdminRoleButton
    ${result2}=    Check membership 
    
    Click On Table Cell    membershipTable    ${row_number}    0
    Push Button    revokeRoleButton
    ${result3}=    Check membership
    
    Execute Immediate    DROP ${type} TEST_USER
    Execute Immediate    DROP ROLE ATEST_ROLE

    Should Be Equal    ${result1}    [('TEST_USER ', 'M', 0, 'ATEST_ROLE')]
    Should Be Equal    ${result2}    [('TEST_USER ', 'M', 2, 'ATEST_ROLE')]
    Should Be Equal    ${result3}    []

Check membership
    ${result}=    Execute    select CAST(rdb$user as VARCHAR(10)), CAST(rdb$privilege as VARCHAR(1)), rdb$grant_option, CAST(rdb$relation_name as VARCHAR(10)) from RDB$USER_PRIVILEGES where rdb$user='TEST_USER'
    RETURN     ${result}
