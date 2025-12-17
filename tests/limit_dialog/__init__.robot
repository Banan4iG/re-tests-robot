*** Settings ***
Resource    ../../files/keywords.resource
Suite Setup    Suite Setup
Suite Teardown    Suite Teardown

*** Keywords ***
Suite Setup
    Add Rows    104857

Suite Teardown
    Execute Immediate    DROP TABLE TEST_TABLE