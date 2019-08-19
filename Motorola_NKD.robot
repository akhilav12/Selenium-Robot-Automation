*** Settings ***
Library           RequestsLibrary
Library           OperatingSystem
Library           String
Library           XML
Library           Collections
Library           DateTime
Library           String
Library           ExcelLibrary

*** Variables ***
${BASE_URL}       http://10.184.42.244:3453
${REQ_FILE_PATH}    C:\\Users\\etwxxbe\\Documents\\Motorola\\Motorola_NKD\\Motorola_NKD\\Make_adjustment
${Relative_URL}    /wsi/services/ws_CIL_7_NkMakeAdjustmentCreateService.wsdl
${EXCEL_PATH}     C:\\Users\\etwxxbe\\Documents\\Motorola\\Motorola_NKD\\Motorola_NKD\\DATA.xls
${adjustmentTransactionId}    102

*** Test Cases ***
NK_MAKE_ADJUSTMENT_CREATE
    Create Session    Make_Adjustment_Create_Session    ${BASE_URL}
    ${header}    Create Dictionary    content-type=text/xml
    ${date}    Get Current Date    result_format=%Y-%m-%d
    ${Request}    Get File    ${REQ_FILE_PATH}    encoding_errors=False
    ${Request}    Replace String    ${Request}    CurrentDate    ${date}
    Open Excel    ${EXCEL_PATH}
    ${rowcount}=    Get Row Count    TestSheet1
    : FOR    ${N}    IN RANGE    1    ${rowcount}
    \    ${reasonId}    Read Cell Data By Name    TestSheet1    A2
    \    ${Request}    Replace String    ${Request}    RS_ID    ${reasonId}
    \    ${adjType}    Read Cell Data By Name    TestSheet1    B2
    \    ${Request}    Replace String    ${Request}    ADJUST_TYPE    ${adjType}
    \    ${amount}    Read Cell Data By Name    TestSheet1    C2
    \    ${amount}    Convert To String    ${amount}
    \    ${Request}    Replace String    ${Request}    ADJUST_AMOUNT    ${amount}
    \    ${adjAmount_currency}    Read Cell Data By Name    TestSheet1    D2
    \    ${Request}    Replace String    ${Request}    ADJUST_CURRENCY    ${adjAmount_currency}
    \    ${vat}    Read Cell Data By Name    TestSheet1    E2
    \    ${Request}    Replace String    ${Request}    AMOUNT_VAT    ${vat}
    \    ${adjReceiverType}    Read Cell Data By Name    TestSheet1    F2
    \    ${Request}    Replace String    ${Request}    RECEIVER_TYPE    ${adjReceiverType}
    \    ${adjReceiverId}    Read Cell Data By Name    TestSheet1    G2
    \    ${Request}    Replace String    ${Request}    RECEIVER_ID    ${adjReceiverId}
    \    ${ssiUserId}    Read Cell Data By Name    TestSheet1    H2
    \    ${Request}    Replace String    ${Request}    USER_ID    ${ssiUserId}
    \    ${ssiTransactionId}    Read Cell Data By Name    TestSheet1    I2
    \    Convert To String    ${ssiTransactionId}
    \    ${Request}    Replace String    ${Request}    TRAN_ID    ${ssiTransactionId}
    \    ${key}    Read Cell Data By Name    TestSheet1    J2
    \    ${Request}    Replace String    ${Request}    KEY_ID    ${key}
    \    ${value}    Read Cell Data By Name    TestSheet1    K2
    \    Convert To String    ${value}
    \    ${Request}    Replace String    ${Request}    VALUE_NO    ${value}
    \    ${Response}    Post Request    Make_Adjustment_Create_Session    ${Relative_URL}    data=${Request}    headers=${header}
    \    Log To Console    ${Response.text}
    \    Exit For Loop
    Should Be Equal    ${Response.text}    200
    Should Be Equal    ${adjustmentTransactionId}    102
