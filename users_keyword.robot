*** Settings ***
Resource    ../resource/global_resource.robot
Resource    ../resource/authentication.robot
Resource    ../resource/api_staging_true-e-logistics.robot

*** Keywords ***
Validation Http status code success 200 OK
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    200

Validation Http status code success 201 Created
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    201

Validation Http status code 400 Bad request
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    400

Validation Http status code 401 Unauthorized
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    401

Validation Http status code 403 Forbidden
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    403

Validation Http status code 404 Not Found
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    404

Validation Http status code 500 Internal Server Error
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    500

Validation Http status code Bad Gateway
    [Arguments]                   ${http_status_res_code}
    Should Be Equal As Strings    ${http_status_res_code}    502

#Create Order Derivery
Create Order
    Create Session                  api                    ${url}
    ${body}=                        Get Binary File        ${CURDIR}${/}TrueRyde_CreateOrderDerivery/TC_001_create_order.json
    # ${random}         Generate random string    3    0123456789
    # set to dictionary    ${body}    consignment=TESTGAME${random}
    # ${body}=    evaluate    json.dumps{}    json
    &{headers}=                     Create Dictionary      api-key=${api-key-cpall}    Content-Type=${Content-Type}
    ${resp}=                        Post Request           api    ${Path_CreateOrder}    data=${body}    headers=${headers}
    Log                             ${resp}
    Should Be Equal As Strings      ${resp.status_code}    200
    ${order_id}=                    Get From Dictionary    ${resp.json()["data"]["data"]["result"][0]["metadata"]}    orderId
    Log                             ${order_id}
    Set Global Variable             ${order_id}
    Sleep    10

Cancel Order
    Create Session                  api                    ${url}
    ${body}=                        Get Binary File        ${CURDIR}${/}TrueRyde_CreateOrderDerivery/body_cancel_order.json
    &{headers}=                     Create Dictionary      api-key=${api-key-sendit}    Content-Type=${Content-Type}
    ${resp2}=                       Post Request           api    /trueryde-delivery/manage/order/${order_id}/cancel    data=${body}    headers=${headers}
    Log                             ${resp2}
    Should Be Equal As Strings      ${resp2.status_code}    200

Failed Order
    Create Session                  api                    ${url}
    ${body}=                        Get Binary File        ${CURDIR}${/}TrueRyde_CreateOrderDerivery/body_failed_order.json
    &{headers}=                     Create Dictionary      api-key=${api-key-sendit}    Content-Type=${Content-Type}
    ${resp3}=                       Post Request           api    /trueryde-delivery/manage/order/${order_id}/cancel    data=${body}    headers=${headers}
    Log                             ${resp3}
    Should Be Equal As Strings      ${resp3.status_code}    200

#Send Notification Driver
Send Notification & Message Driver
    Create Session                  api                    ${url}
    ${body}=                        Get Binary File        ${CURDIR}${/}TrueRyde_SenddNotification/TC_001_send_notification_driver.json
    &{headers}=                     Create Dictionary      Content-Type=${Content-Type}
    ${resp}=                        Post Request           api    /4pl-notification/v1/notification/message    data=${body}    headers=${headers}
    Log                             ${resp}
    Should Be Equal As Strings      ${resp.status_code}    200

#Send Notification Passenger
Send Notification & Message Passenger
    Create Session                  api                    ${url}
    ${body}=                        Get Binary File        ${CURDIR}${/}TrueRyde_SenddNotification/TC_002_send_notification_passenger.json
    &{headers}=                     Create Dictionary      Content-Type=${Content-Type}
    ${resp}=                        Post Request           api    /4pl-notification/v1/notification/message    data=${body}    headers=${headers}
    Log                             ${resp}
    Should Be Equal As Strings      ${resp.status_code}    200

#Create Voucher
Create Voucher
    Create Session                  api                    ${url}
    ${headers}=                     Create Dictionary      Content-Type=${Content-Type}
    ${json_string}                  Get File               TC_001_create_voucher.json
    ${resp}=                        Post Request           session       ${Path_CreateVoucher}       data=${json_string}     headers=${headers}
    ${http_status_res_code}=        Set Variable           ${resp.status_code}
    log                             ${resp.json()}    
    Validation Http status code success 200 OK             ${http_status_res_code}