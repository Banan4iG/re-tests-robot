*** Settings ***
Library     RemoteSwingLibrary
Resource    ../../files/keywords.resource


*** Keywords ***
Local Test Setup
    Backup Savedconnections File
    Test Setup

Local Test Teardown
    System Exit    0
    Unlock Employee
    Clear History Files
    Restore Savedconnections File
