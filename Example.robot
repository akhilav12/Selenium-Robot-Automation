*** Settings ***
Library           RequestsLibrary
Library           OperatingSystem
Library           String
Library           XML
Library           Collections
Library           DateTime
Library           String
Library           ExcelLibrary
Library           ExcelRead.py

*** Variables ***
${BASE_URL}       http://10.184.42.244:3453
${REQ_FILE_PATH}    C:\\Users\\etwxxbe\\Documents\\Motorola\\Motorola_NKD\\Motorola_NKD\\Make_adjustment
${Relative_URL}    /wsi/services/ws_CIL_7_NkMakeAdjustmentCreateService.wsdl
${EXCEL_PATH}     C:\\Users\\etwxxbe\\Documents\\Motorola\\Motorola_NKD\\Motorola_NKD\\DATA.xlsx
${adjustmentTransactionId}    102
${Pattern}        adjustmentTransactionId

*** Test Cases ***
NK_MAKE_ADJUSTMENT_CREATE
    Create Session    Make_Adjustment_Create_Session    ${BASE_URL}
    ${header}    Create Dictionary    content-type=text/xml
    ${date}    Get Current Date    result_format=%Y-%m-%d
    ${Request}    Get File    ${REQ_FILE_PATH}    encoding_errors=False
    ${Request}    Replace String    ${Request}    CurrentDate    ${date}
    @{ExcelValues}    ExteranetExcelRead    ${EXCEL_PATH}
    : FOR    ${i}    IN    @{ExcelValues}
    \    &{Dict}    Set Variable    ${i}
    \    ${reasonId}    Get From Dictionary    ${Dict}    reasonId
    \    ${adjType}    Get From Dictionary    ${Dict}    adjType
    \    ${adjAmount}    Get From Dictionary    ${Dict}    adjAmount
    \    ${adjAmount_currency}    Get From Dictionary    ${Dict}    adjAmount_currency
    \    ${vat}    Get From Dictionary    ${Dict}    vat
    \    ${adjReceiverType}    Get From Dictionary    ${Dict}    adjReceiverType
    \    ${adjReceiverId}    Get From Dictionary    ${Dict}    adjReceiverId
    \    ${ssiUserId}    Get From Dictionary    ${Dict}    ssiUserId
    \    ${ssiTransactionId}    Get From Dictionary    ${Dict}    ssiTransactionId
    \    ${key}    Get From Dictionary    ${Dict}    key
    \    ${value}    Get From Dictionary    ${Dict}    value
    \    log    ${reasonId}
    \    log    ${adjType}
    \    log    ${adjAmount}
    \    log    ${adjAmount_currency}
    \    log    ${vat}
    \    log    ${adjReceiverType}
    \    ${Request}    Replace String    ${Request}    ADJUST_TYPE    ${adjType}
    \    ${Request}    Replace String    ${Request}    AMOUNT_VAT    ${vat}
    \    ${Request}    Replace String    ${Request}    ADJUST_CURRENCY    ${adjAmount_currency}
    \    ${Request}    Replace String    ${Request}    ADJUST_TYPE    ${adjType}
    \    ${Request}    Replace String    ${Request}    RS_ID    ${reasonId}
    \    ${Request}    Replace String    ${Request}    USER_ID    ${ssiUserId}
    \    ${Request}    Replace String    ${Request}    TRAN_ID    ${ssiTransactionId}
    \    ${Request}    Replace String    ${Request}    KEY_ID    ${key}
    \    ${Request}    Replace String    ${Request}    VALUE_NO    ${value}
    \    ${Request}    Replace String    ${Request}    RECEIVER_TYPE    ${adjReceiverType}
    ${Response}    Post Request    Make_Adjustment_Create_Session    ${Relative_URL}    data=${Request}    headers=${header}
    Log To Console    ${Response.text}
    ${Response_code}    Convert to string    ${Response.status_code}
    Should Be Equal    ${Response_code}    200
    Should Contain    ${Response.text}    ${Pattern}
