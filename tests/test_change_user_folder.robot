*** Settings ***
Library             String
Library             RemoteSwingLibrary
Resource            ../files/keywords.resource

Test Setup          Local Test Setup
Test Timeout        120s


*** Test Cases ***
test_1
    ${DIST}=    Get Environment Variable    DIST    D:\\projects\\RDBExpert
    ${user_home}=    Normalize Path    ~
    VAR    ${rdbexpert_in_user_path}    ${user_home}${/}.rdbexpert
    VAR    ${rdbexpert_in_tmp_path}    ${TEMPDIR}${/}.rdbexpert
    VAR    ${rdbexpert_in_relative_path}    ${DIST}${/}.rdbexpert_test

    ${rdbexpert_in_user_path_n}=    Replace String    ${rdbexpert_in_user_path}    \\    /
    ${rdbexpert_in_tmp_path_n}=    Replace String    ${rdbexpert_in_tmp_path}    \\    /
    ${rdbexpert_in_relative_path_n}=    Replace String    ${rdbexpert_in_relative_path}    \\    /

    VAR    ${config_path}    ${DIST}${/}config${/}launcher.conf
    VAR    ${config_path_bk}    ${DIST}${/}config${/}launcher.conf.bak
    Copy File    ${config_path}    ${config_path_bk}

    ${config_content}=    Get File    ${config_path}
    ${new_config_content_1}=    Replace String Using Regexp
    ...    string=${config_content}
    ...    pattern=app.settings.directory=.*
    ...    replace_with=app.settings.directory=

    ${new_config_content_2}=    Replace String Using Regexp
    ...    string=${config_content}
    ...    pattern=app.settings.directory=.*
    ...    replace_with=app.settings.directory=${rdbexpert_in_tmp_path_n}

    ${new_config_content_3}=    Replace String Using Regexp
    ...    string=${config_content}
    ...    pattern=app.settings.directory=.*
    ...    replace_with=app.settings.directory=.rdbexpert_test

    Create File    ${config_path}    ${new_config_content_1}
    Start RDB Expert
    Select Main Window
    Open Connection
    Close Connection
    Directory Should Exist    ${rdbexpert_in_user_path_n}
    Directory Should Not Be Empty    ${rdbexpert_in_user_path_n}
    Local Test Setup

    Create File    ${config_path}    ${new_config_content_2}
    Start RDB Expert
    Directory Should Exist    ${rdbexpert_in_tmp_path_n}
    Directory Should Not Be Empty    ${rdbexpert_in_tmp_path_n}
    Local Test Setup
    Sleep    5s
    Remove Directory    ${rdbexpert_in_tmp_path_n}    ${True}

    Create File    ${config_path}    ${new_config_content_3}
    Start RDB Expert
    Directory Should Exist    ${rdbexpert_in_relative_path_n}
    Directory Should Not Exist    ${EXECDIR}${/}.rdbexpert_test
    Directory Should Not Be Empty    ${rdbexpert_in_relative_path_n}
    Local Test Setup
    Sleep    5s
    Remove Directory    ${rdbexpert_in_relative_path_n}    ${True}

    [Teardown]    Local Test Teardown    ${config_path}    ${config_path_bk}


*** Keywords ***
Local Test Setup
    TRY
        Kill Rdbexpert
    EXCEPT    message
        Log    RDBExpert not running
    END

Local Test Teardown
    Local Test Setup
    [Arguments]    ${config_path}    ${config_path_bk}
    Copy File    ${config_path_bk}    ${config_path}
    Remove File    ${config_path_bk}
