*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_without
    Setup before export data
    ${export_path}=    Init XML

    ${expected_content}=    Catenate    SEPARATOR=\n    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <FIRST_NAME><![CDATA[Carol]]></FIRST_NAME> <LAST_NAME><![CDATA[Nordstrom]]></LAST_NAME> <PHONE_EXT><![CDATA[420]]></PHONE_EXT> <HIRE_DATE>1991-10-02T00:00</HIRE_DATE> </row> <row number="2"> <FIRST_NAME><![CDATA[Luke]]></FIRST_NAME> <LAST_NAME><![CDATA[Leung]]></LAST_NAME> <PHONE_EXT><![CDATA[3]]></PHONE_EXT> <HIRE_DATE>1992-02-18T00:00</HIRE_DATE> </row> <row number="3"> <FIRST_NAME><![CDATA[Sue Anne]]></FIRST_NAME> <LAST_NAME><![CDATA[O'Brien]]></LAST_NAME> <PHONE_EXT><![CDATA[877]]></PHONE_EXT> <HIRE_DATE>1992-03-23T00:00</HIRE_DATE> </row> <row number="4"> <FIRST_NAME><![CDATA[Jennifer M.]]></FIRST_NAME> <LAST_NAME><![CDATA[Burbank]]></LAST_NAME> <PHONE_EXT><![CDATA[289]]></PHONE_EXT> <HIRE_DATE>1992-04-15T00:00</HIRE_DATE> </row> <row number="5"> <FIRST_NAME><![CDATA[Claudia]]></FIRST_NAME> <LAST_NAME><![CDATA[Sutherland]]></LAST_NAME> <PHONE_EXT/> <HIRE_DATE>1992-04-20T00:00</HIRE_DATE> </row> <row number="6"> <FIRST_NAME><![CDATA[Dana]]></FIRST_NAME> <LAST_NAME><![CDATA[Bishop]]></LAST_NAME> <PHONE_EXT><![CDATA[290]]></PHONE_EXT> <HIRE_DATE>1992-06-01T00:00</HIRE_DATE> </row> </data> </result-set>    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_replace_null
    Setup before export data
    ${export_path}=    Init XML
    Check Check Box    replaceNullCheck
    Clear Text Field    replaceNullField
    Type Into Text Field    replaceNullField    LLUN
    Push Button    exportButton

    ${expected_content}=    Catenate    SEPARATOR=\n    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <FIRST_NAME><![CDATA[Carol]]></FIRST_NAME> <LAST_NAME><![CDATA[Nordstrom]]></LAST_NAME> <PHONE_EXT><![CDATA[420]]></PHONE_EXT> <HIRE_DATE>1991-10-02T00:00</HIRE_DATE> </row> <row number="2"> <FIRST_NAME><![CDATA[Luke]]></FIRST_NAME> <LAST_NAME><![CDATA[Leung]]></LAST_NAME> <PHONE_EXT><![CDATA[3]]></PHONE_EXT> <HIRE_DATE>1992-02-18T00:00</HIRE_DATE> </row> <row number="3"> <FIRST_NAME><![CDATA[Sue Anne]]></FIRST_NAME> <LAST_NAME><![CDATA[O'Brien]]></LAST_NAME> <PHONE_EXT><![CDATA[877]]></PHONE_EXT> <HIRE_DATE>1992-03-23T00:00</HIRE_DATE> </row> <row number="4"> <FIRST_NAME><![CDATA[Jennifer M.]]></FIRST_NAME> <LAST_NAME><![CDATA[Burbank]]></LAST_NAME> <PHONE_EXT><![CDATA[289]]></PHONE_EXT> <HIRE_DATE>1992-04-15T00:00</HIRE_DATE> </row> <row number="5"> <FIRST_NAME><![CDATA[Claudia]]></FIRST_NAME> <LAST_NAME><![CDATA[Sutherland]]></LAST_NAME> <PHONE_EXT>LLUN</PHONE_EXT> <HIRE_DATE>1992-04-20T00:00</HIRE_DATE> </row> <row number="6"> <FIRST_NAME><![CDATA[Dana]]></FIRST_NAME> <LAST_NAME><![CDATA[Bishop]]></LAST_NAME> <PHONE_EXT><![CDATA[290]]></PHONE_EXT> <HIRE_DATE>1992-06-01T00:00</HIRE_DATE> </row> </data> </result-set>    ${EMPTY}
    Check content    ${export_path}    ${expected_content}

test_execute_to_file
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    SELECT * FROM COUNTRY
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s  
    Select Dialog    Export Data
    ${export_path}=    Init XML
    ${expected_content}=    Catenate    SEPARATOR=\n    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <COUNTRY><![CDATA[USA]]></COUNTRY> <CURRENCY><![CDATA[Dollar]]></CURRENCY> </row> <row number="2"> <COUNTRY><![CDATA[England]]></COUNTRY> <CURRENCY><![CDATA[Pound]]></CURRENCY> </row> <row number="3"> <COUNTRY><![CDATA[Canada]]></COUNTRY> <CURRENCY><![CDATA[CdnDlr]]></CURRENCY> </row> <row number="4"> <COUNTRY><![CDATA[Switzerland]]></COUNTRY> <CURRENCY><![CDATA[SFranc]]></CURRENCY> </row> <row number="5"> <COUNTRY><![CDATA[Japan]]></COUNTRY> <CURRENCY><![CDATA[Yen]]></CURRENCY> </row> <row number="6"> <COUNTRY><![CDATA[Italy]]></COUNTRY> <CURRENCY><![CDATA[Euro]]></CURRENCY> </row> <row number="7"> <COUNTRY><![CDATA[France]]></COUNTRY> <CURRENCY><![CDATA[Euro]]></CURRENCY> </row> <row number="8"> <COUNTRY><![CDATA[Germany]]></COUNTRY> <CURRENCY><![CDATA[Euro]]></CURRENCY> </row> <row number="9"> <COUNTRY><![CDATA[Australia]]></COUNTRY> <CURRENCY><![CDATA[ADollar]]></CURRENCY> </row> <row number="10"> <COUNTRY><![CDATA[Hong Kong]]></COUNTRY> <CURRENCY><![CDATA[HKDollar]]></CURRENCY> </row> <row number="11"> <COUNTRY><![CDATA[Netherlands]]></COUNTRY> <CURRENCY><![CDATA[Euro]]></CURRENCY> </row> <row number="12"> <COUNTRY><![CDATA[Belgium]]></COUNTRY> <CURRENCY><![CDATA[Euro]]></CURRENCY> </row> <row number="13"> <COUNTRY><![CDATA[Austria]]></COUNTRY> <CURRENCY><![CDATA[Euro]]></CURRENCY> </row> <row number="14"> <COUNTRY><![CDATA[Fiji]]></COUNTRY> <CURRENCY><![CDATA[FDollar]]></CURRENCY> </row> <row number="15"> <COUNTRY><![CDATA[Russia]]></COUNTRY> <CURRENCY><![CDATA[Ruble]]></CURRENCY> </row> <row number="16"> <COUNTRY><![CDATA[Romania]]></COUNTRY> <CURRENCY><![CDATA[RLeu]]></CURRENCY> </row> </data> </result-set>    ${EMPTY}
    Check content    ${export_path}    ${expected_content}


*** Keywords ***
Init XML
    Select From Combo Box    typeCombo    XML
    ${export_path}=    Catenate    SEPARATOR=    ${TEMPDIR}    /export.xml
    Remove Files    ${export_path}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}
    Uncheck All Checkboxes
    RETURN    ${export_path}

Check content
    [Arguments]   ${export_path}    ${expected_content}
    Push Button    exportButton
    Sleep    1s
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}