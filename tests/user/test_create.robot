*** Settings ***
Library    RemoteSwingLibrary
Library    String
Resource   ../../files/keywords.resource
Test Setup       Setup
Test Teardown    Teardown after every tests

*** Test Cases ***

test_create_active_user_with_default_plugin
    Create User With Options    TEST_USER_1    John    M    Doe    password=123    plugin=Srp    role=ACTIVE

test_create_admin_user_with_custom_plugin
    Create User With Options    TEST_USER_2    Jane    A    Smith    password=456    plugin=Legacy_UserManager    role=ADMINISTRATOR

test_create_user_with_comment
    Create User With Options    TEST_COMMENT    Alice    R    Johnson    password=789    comment=This is a test user

test_check_sql_before_apply
    Create User With Options And Check SQL    TEST_SQL_PREVIEW    FirstName    Mid    LastName    password=123    plugin=Srp    role=ACTIVE


*** Keywords ***

Create User With Options
    [Arguments]    ${user_name}    ${first_name}=    ${middle_name}=    ${last_name}=    ${password}=123    ${plugin}=Srp    ${role}=ACTIVE    ${comment}=
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (1)    Create user
    Sleep    2s
    Select Dialog    Create user

    # Переключаемся на вкладку "Properties"
    Select Tab    0

    # Основные поля
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${user_name}
    Clear Text Field    1
    Type Into Text Field    1    ${password}

    # First/Middle/Last Name
    Clear Text Field    2
    Type Into Text Field    2    ${first_name}
    Clear Text Field    3
    Type Into Text Field    3    ${middle_name}
    Clear Text Field    4
    Type Into Text Field    4    ${last_name}

    # Выбор плагина
    Select From Combo Box   pluginCombo    ${plugin}

    # Роль: Active или Administrator
    Run Keyword If    "${role}" == "ADMINISTRATOR"
    ...    Set Role To Admin
    ...    ELSE
    ...    Set Role To Active

    # Переходим на вкладку "Comment"
    Select Tab    1

    # Комментарий (если указан)
    Run Keyword If    '${comment}' != ''
    ...    Type Into Text Field    0    ${comment}

    # Возвращаемся на вкладку "Properties"
    Select Tab     0

    # Добавляем метки (Tags)
    # Add Tags    MyTag    MyValue

    # Отправляем форму
    Push Button    submitButton


Check User Creation Command
    [Arguments]    ${expected_sql}    ${user_name}
    Select Dialog    Commiting changes
    Sleep    1s
    ${res}=    Get Text Field Value    0
    Should Be Equal As Strings    ${res}    ${expected_sql}
    Push Button    commitButton
    Sleep    0.1s
    Run Keyword And Expect Error    org.netbeans.jemmy.TimeoutExpiredException: Dialog with name or title 'Create user'    Select Dialog    Create user
    Select Main Window
    Tree Node Should Exist    0     New Connection|Users (2)|${user_name}


Set Role To Active
    Uncheck CheckBox    1
    Uncheck CheckBox    2
    Check CheckBox    1


Set Role To Admin
    Uncheck CheckBox    1
    Uncheck CheckBox    2
    Check CheckBox    2


Create User With Options And Check SQL
    [Arguments]    ${user_name}    ${first_name}=    ${middle_name}=    ${last_name}=    ${password}=123    ${plugin}=Srp    ${role}=ACTIVE
    Lock Employee
    Open connection
    Expand Tree Node    0    New Connection
    Select From Tree Node Popup Menu    0    New Connection|Users (1)    Create user
    Sleep    2s
    Select Dialog    Create user

    # Заполняем основные поля
    Clear Text Field    nameField
    Type Into Text Field    nameField    ${user_name}
    Clear Text Field    1
    Type Into Text Field    1    ${password}

    Clear Text Field    2
    Type Into Text Field    2    ${first_name}
    Clear Text Field    3
    Type Into Text Field    3    ${middle_name}
    Clear Text Field    4
    Type Into Text Field    4    ${last_name}

    # Плагин
    Select From Combo Box   pluginCombo    ${plugin}

    # Роль
    Run Keyword If    "${role}" == "ADMINISTRATOR"
    ...    Set Role To Admin
    ...    ELSE
    ...    Set Role To Active

    # Переключаемся на вкладку SQL
    Select Tab     2

    # Получаем SQL команду
    ${sql}=    Get Text Field Value    0

    

    # Закрываем диалог без сохранения
    Push Button    cancelButton


Setup
    Skip