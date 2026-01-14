*** Settings ***
Library             RemoteSwingLibrary
Resource            ../../../files/keywords.resource
Resource            ../keys.resource

Test Setup          Setup Before Every Tests
Test Teardown       Teardown After Every Tests


*** Test Cases ***
test_active
    Popup Active    CREATE OR ALTER TRIGGER NEW_TRIGGER ACTIVE ON CONNECT POSITION 0 AS BEGIN END    DB Triggers (1)
