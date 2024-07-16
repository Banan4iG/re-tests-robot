*** Settings ***
Library    RemoteSwingLibrary
Library    Process
Library    Collections
Resource    ../files/keywords.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_1
    Create New Conn
    Select From Tree Node Popup Menu    0    New Connection 1    Connect
    Tree Node Should Not Be Leaf        0    New Connection 1

test_2
    Create New Conn
    Click On Tree Node              0    New Connection 1    2
    Tree Node Should Not Be Leaf    0    New Connection 1

*** Keywords ***
Create New Conn
    Push Button    new-connection-command
    Type Into Text Field    3    employee.fdb
    List Components In Context
    Type Into Text Field    5    sysdba
    Type Into Text Field    6    masterkey
    Check Check Box    Store Password