*** Settings ***
Library    RemoteSwingLibrary
Library    OperatingSystem
Resource    ../../files/keywords.resource
Resource    key.resource
Test Setup       Setup before every tests
Test Teardown    Teardown after every tests

*** Test Cases ***
test_CSV_export_to_folder
    Init
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.csv
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck
 
    ${blob_path1}    ${blob_path2}    ${blob_path3}    ${blob_path4}    ${blob_path5}    ${blob_path6}=    Check blobs in folder    ${export_blob}

    ${expected_content}=    Catenate    SEPARATOR=\n    VBASE;Video Database;${blob_path1};45;software    DGPII;DigiPizza;${blob_path2};24;other    GUIDE;AutoMap;${blob_path3};20;hardware    MAPDB;MapBrowser port;${blob_path4};4;software    HWRII;Translator upgrade;${blob_path5};;software    MKTPR;Marketing project 3;${blob_path6};85;N/A    ${EMPTY}
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}

test_XML_export_to_folder
    Init
    Select From Combo Box    typeCombo    XML
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xml
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck

    ${blob_path1}    ${blob_path2}    ${blob_path3}    ${blob_path4}    ${blob_path5}    ${blob_path6}=    Check blobs in folder    ${export_blob}

    VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_ID><![CDATA[VBASE]]></PROJ_ID> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>${blob_path1}</PROJ_DESC> <TEAM_LEADER>45</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="2"> <PROJ_ID><![CDATA[DGPII]]></PROJ_ID> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>${blob_path2}</PROJ_DESC> <TEAM_LEADER>24</TEAM_LEADER> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="3"> <PROJ_ID><![CDATA[GUIDE]]></PROJ_ID> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>${blob_path3}</PROJ_DESC> <TEAM_LEADER>20</TEAM_LEADER> <PRODUCT><![CDATA[hardware]]></PRODUCT> </row> <row number="4"> <PROJ_ID><![CDATA[MAPDB]]></PROJ_ID> <PROJ_NAME><![CDATA[MapBrowser port]]></PROJ_NAME> <PROJ_DESC>${blob_path4}</PROJ_DESC> <TEAM_LEADER>4</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="5"> <PROJ_ID><![CDATA[HWRII]]></PROJ_ID> <PROJ_NAME><![CDATA[Translator upgrade]]></PROJ_NAME> <PROJ_DESC>${blob_path5}</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="6"> <PROJ_ID><![CDATA[MKTPR]]></PROJ_ID> <PROJ_NAME><![CDATA[Marketing project 3]]></PROJ_NAME> <PROJ_DESC>${blob_path6}</PROJ_DESC> <TEAM_LEADER>85</TEAM_LEADER> <PRODUCT><![CDATA[N/A]]></PRODUCT> </row> </data> </result-set>
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_XLSX_export_to_folder
    Init
    Select From Combo Box    typeCombo    XLSX
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xlsx
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck
    Check Check Box    addColumnHeadersCheck

    ${blob_path1}    ${blob_path2}    ${blob_path3}    ${blob_path4}    ${blob_path5}    ${blob_path6}=    Check blobs in folder    ${export_blob}

    VAR    ${expected_content}    PROJ_ID PROJ_NAME PROJ_DESC TEAM_LEADER PRODUCT VBASE Video Database ${blob_path1} 45.0 software DGPII DigiPizza ${blob_path2} 24.0 other GUIDE AutoMap ${blob_path3} 20.0 hardware MAPDB MapBrowser port ${blob_path4} 4.0 software HWRII Translator upgrade ${blob_path5} software MKTPR Marketing project 3 ${blob_path6} 85.0 N/A    
    File Should Exist    ${export_path}
    ${content}=    Check Xlsx    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

test_SQL_export_to_folder
    Init
    Select From Combo Box    typeCombo    SQL
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.sql
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob
    Remove Files    ${export_path}
    Remove Directory    ${export_blob}    ${True}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Check Check Box    saveBlobsIndividuallyCheck

    Check Check Box    addCreateTableStatementCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE
    
    ${blob_path1}    ${blob_path2}    ${blob_path3}    ${blob_path4}    ${blob_path5}    ${blob_path6}=    Check blobs in folder    ${export_blob}

    VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_ID CHAR(5), PROJ_NAME VARCHAR(20), PROJ_DESC BLOB SUB_TYPE 1, TEAM_LEADER SMALLINT, PRODUCT VARCHAR(12) ); -- inserting data -- INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'VBASE', 'Video Database', ?'${blob_path1}', 45, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DGPII', 'DigiPizza', ?'${blob_path2}', 24, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'GUIDE', 'AutoMap', ?'${blob_path3}', 20, 'hardware' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MAPDB', 'MapBrowser port', ?'${blob_path4}', 4, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'HWRII', 'Translator upgrade', ?'${blob_path5}', NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MKTPR', 'Marketing project 3', ?'${blob_path6}', 85, 'N/A' );    
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}



test_CSV_export_to_file
    Init
    Select From Combo Box    typeCombo    CSV
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.csv
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    ${expected_content}=    Catenate    SEPARATOR=\n    VBASE;Video Database;:h00000000_00000059;45;software    DGPII;DigiPizza;:h00000059_00000077;24;other    GUIDE;AutoMap;:h000000d0_00000055;20;hardware    MAPDB;MapBrowser port;:h00000125_00000048;4;software    HWRII;Translator upgrade;:h0000016d_00000056;;software    MKTPR;Marketing project 3;:h000001c3_00000061;85;N/A    ${EMPTY}
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}

    Check blobs in file    ${export_blob}

test_XML_export_to_file
    Init
    Select From Combo Box    typeCombo    XML
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xml
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    VAR    ${expected_content}    <?xml version="1.0" encoding="UTF-8" standalone="no"?> <result-set> <data> <row number="1"> <PROJ_ID><![CDATA[VBASE]]></PROJ_ID> <PROJ_NAME><![CDATA[Video Database]]></PROJ_NAME> <PROJ_DESC>:h00000000_00000059</PROJ_DESC> <TEAM_LEADER>45</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="2"> <PROJ_ID><![CDATA[DGPII]]></PROJ_ID> <PROJ_NAME><![CDATA[DigiPizza]]></PROJ_NAME> <PROJ_DESC>:h00000059_00000077</PROJ_DESC> <TEAM_LEADER>24</TEAM_LEADER> <PRODUCT><![CDATA[other]]></PRODUCT> </row> <row number="3"> <PROJ_ID><![CDATA[GUIDE]]></PROJ_ID> <PROJ_NAME><![CDATA[AutoMap]]></PROJ_NAME> <PROJ_DESC>:h000000d0_00000055</PROJ_DESC> <TEAM_LEADER>20</TEAM_LEADER> <PRODUCT><![CDATA[hardware]]></PRODUCT> </row> <row number="4"> <PROJ_ID><![CDATA[MAPDB]]></PROJ_ID> <PROJ_NAME><![CDATA[MapBrowser port]]></PROJ_NAME> <PROJ_DESC>:h00000125_00000048</PROJ_DESC> <TEAM_LEADER>4</TEAM_LEADER> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="5"> <PROJ_ID><![CDATA[HWRII]]></PROJ_ID> <PROJ_NAME><![CDATA[Translator upgrade]]></PROJ_NAME> <PROJ_DESC>:h0000016d_00000056</PROJ_DESC> <TEAM_LEADER/> <PRODUCT><![CDATA[software]]></PRODUCT> </row> <row number="6"> <PROJ_ID><![CDATA[MKTPR]]></PROJ_ID> <PROJ_NAME><![CDATA[Marketing project 3]]></PROJ_NAME> <PROJ_DESC>:h000001c3_00000061</PROJ_DESC> <TEAM_LEADER>85</TEAM_LEADER> <PRODUCT><![CDATA[N/A]]></PRODUCT> </row> </data> </result-set>    
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

    Check blobs in file    ${export_blob}

test_XLSX_export_to_file
    Init
    Select From Combo Box    typeCombo    XLSX
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.xlsx
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}

    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    VAR    ${expected_content}    None None None None None VBASE Video Database :h00000000_00000059 45.0 software DGPII DigiPizza :h00000059_00000077 24.0 other GUIDE AutoMap :h000000d0_00000055 20.0 hardware MAPDB MapBrowser port :h00000125_00000048 4.0 software HWRII Translator upgrade :h0000016d_00000056 software MKTPR Marketing project 3 :h000001c3_00000061 85.0 N/A    
    File Should Exist    ${export_path}
    ${content}=    Check Xlsx    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}    strip_spaces=${True}    collapse_spaces=${True}

    Check blobs in file    ${export_blob}

test_SQL_export_to_file
    Init
    Select From Combo Box    typeCombo    SQL
    ${export_path}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export.sql
    ${export_blob}=     Catenate    SEPARATOR=    ${TEMPDIR}    ${/}export_blob.txt
    Remove Files    ${export_path}    ${export_blob}
    Clear Text Field    filePathField
    Type Into Text Field    filePathField    ${export_path}

    Clear Text Field    folderPathField
    Type Into Text Field    folderPathField    ${export_blob}

    Check Check Box    addCreateTableStatementCheck
    Clear Text Field    exportTableNameField
    Type Into Text Field    exportTableNameField    TEST_TABLE

    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    VAR    ${expected_content}    -- table creating -- CREATE TABLE TEST_TABLE ( PROJ_ID CHAR(5), PROJ_NAME VARCHAR(20), PROJ_DESC BLOB SUB_TYPE 1, TEAM_LEADER SMALLINT, PRODUCT VARCHAR(12) ); -- inserting data -- SET BLOBFILE '${export_blob}'; INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'VBASE', 'Video Database', :h00000000_00000059, 45, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'DGPII', 'DigiPizza', :h00000059_00000077, 24, 'other' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'GUIDE', 'AutoMap', :h000000d0_00000055, 20, 'hardware' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MAPDB', 'MapBrowser port', :h00000125_00000048, 4, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'HWRII', 'Translator upgrade', :h0000016d_00000056, NULL, 'software' ); INSERT INTO TEST_TABLE ( PROJ_ID, PROJ_NAME, PROJ_DESC, TEAM_LEADER, PRODUCT ) VALUES ( 'MKTPR', 'Marketing project 3', :h000001c3_00000061, 85, 'N/A' );
    File Should Exist    ${export_path}
    ${content}=    Get File    ${export_path}
    Should Be Equal As Strings    ${content}    ${expected_content}     strip_spaces=${True}    collapse_spaces=${True}

    Check blobs in file    ${export_blob}


*** Keywords ***
Init
    Open connection
    Clear Text Field    0
    Type Into Text Field    0    select * from PROJECT
    Push Button    editor-execute-to-file-command
    Push Button    execute-script-command
    Sleep    1s
    Select Dialog    Export Data    


Check blobs in folder
    [Arguments]       ${export_blob}
    Push Button    exportButton
    Sleep    5s
    Close Dialog    Message
    Directory Should Exist    ${export_blob}
    Directory Should Not Be Empty    ${export_blob}
    ${blob_path1}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_0.txt
    ${blob_path2}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_1.txt
    ${blob_path3}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_2.txt
    ${blob_path4}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_3.txt
    ${blob_path5}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_4.txt
    ${blob_path6}=     Catenate    SEPARATOR=    ${export_blob}    ${/}PROJ_DESC_5.txt
    
    ${content1}=    Get File    ${blob_path1}
    ${content2}=    Get File    ${blob_path2}
    ${content3}=    Get File    ${blob_path3}
    ${content4}=    Get File    ${blob_path4}
    ${content5}=    Get File    ${blob_path5}
    ${content6}=    Get File    ${blob_path6}

    Should Be Equal As Strings    ${content1}    Design a video data base management system for controlling on-demand video distribution.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content2}    Develop second generation digital pizza maker with flash-bake heating element and digital ingredient measuring system.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content3}    Develop a prototype for the automobile version of the hand-held map browsing device.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content4}    Port the map browsing database software to run on the automobile model.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content5}    Integrate the hand-writing recognition module into the universal language translator.    strip_spaces=${True}    collapse_spaces=${True}
    Should Be Equal As Strings    ${content6}    Expand marketing and sales in the Pacific Rim. Set up a field office in Australia and Singapore.    strip_spaces=${True}    collapse_spaces=${True}
    
    RETURN    ${blob_path1}    ${blob_path2}    ${blob_path3}    ${blob_path4}    ${blob_path5}    ${blob_path6}

Check blobs in file
    [Arguments]    ${export_blob}
    ${expected_content}=    Catenate    SEPARATOR=\n    Design a video data base management system for    controlling on-demand video distribution.    Develop second generation digital pizza maker    with flash-bake heating element and    digital ingredient measuring system.    Develop a prototype for the automobile version of    the hand-held map browsing device.    Port the map browsing database software to run    on the automobile model.    Integrate the hand-writing recognition module into the    universal language translator.    Expand marketing and sales in the Pacific Rim.    Set up a field office in Australia and Singapore.    ${EMPTY}
    File Should Exist    ${export_blob}
    ${content}=    Get File    ${export_blob}
    Should Be Equal As Strings    ${content}    ${expected_content}