*** Settings ***
Resource    ../resource/global_resource.robot
Resource    ../resource/authentication.robot
Resource    ../resource/api_staging_true-e-logistics.robot

*** Keywords ***
Create Order
    Create Session    api                    ${url}
    ${body}=          Get Binary File        ${CURDIR}${/}bodyJson/body_create_order.json
    # ${random}         Generate random string    3    0123456789
    # set to dictionary    ${body}    consignment=TESTGAME${random}
    # ${body}=    evaluate    json.dumps{}    json
    &{headers}=       Create Dictionary      api-key=${api-key-cpall}    Content-Type=application/json
    ${resp}=          Post Request           api    /trueryde-delivery/v1/order    data=${body}    headers=${headers}
    Log               ${resp}
    Should Be Equal As Strings               ${resp.status_code}    200
    ${order_id}=      Get From Dictionary    ${resp.json()["data"]["data"]["result"][0]["metadata"]}    orderId
    Log               ${order_id}
    Set Global Variable                      ${order_id}
    Sleep    5

Cancel Order
    Create Session    api                    ${url}
    ${body}=          Get Binary File        ${CURDIR}${/}bodyJson/body_cancel_order.json
    &{headers}=       Create Dictionary      api-key=${api-key-sendit}    Content-Type=application/json
    ${resp2}=         Post Request           api    /trueryde-delivery/manage/order/${order_id}/cancel    data=${body}    headers=${headers}
    Log               ${resp2}
    Should Be Equal As Strings               ${resp2.status_code}    200

Failed Order
    Create Session    api                    ${url}
    ${body}=          Get Binary File        ${CURDIR}${/}bodyJson/body_failed_order.json
    &{headers}=       Create Dictionary      api-key=${api-key-sendit}    Content-Type=application/json
    ${resp3}=         Post Request           api    /trueryde-delivery/manage/order/${order_id}/cancel    data=${body}    headers=${headers}
    Log               ${resp3}
    Should Be Equal As Strings               ${resp3.status_code}    200

# --------------------Driver Login & Online---------------------------------------------------------------------------------------------------------------
Login Driver
    Create Session    api                    ${url}
    ${body}=          Get Binary File        ${CURDIR}${/}bodyJson/body_login_driver.json
    &{headers}=       Create Dictionary      Content-Type=application/json
    ${resp}=          Post Request           api    /v2/auth/login-trueid    data=${body}    headers=${headers}
    Log               ${resp}
    Should Be Equal As Strings               ${resp.status_code}    200
    ${token}=         Get From Dictionary    ${resp.json()["data"]}    token
    Log               ${token}
    Set Global Variable                      ${token}

Driver Vehicle List
    Create Session    api                    ${url}
    &{headers}=       Create Dictionary      Content-Type=application/json    Authorization=${token}
    ${resp2}=         Get Request            api    /v1/mobile/driver/vehicles    headers=${headers}
    Log               ${resp2}
    Should Be Equal As Strings               ${resp2.status_code}    200
    ${vehicleId}=     Get From Dictionary    ${resp2.json()["data"][0]}    _id
    Log               ${vehicleId}
    Set Global Variable                      ${vehicleId}

Driver Set Active Vehicle
    Create Session    api                    ${url}
    &{headers}=       Create Dictionary      Content-Type=application/json    Authorization=${token}
    ${resp3}=         Post Request           api    /v1/mobile/driver/vehicles/${vehicleId}/active    headers=${headers}
    Log               ${resp3}
    Should Be Equal As Strings               ${resp3.status_code}    200

Driver Online
    Create Session    api                    ${url}
    ${body}=          Get Binary File        ${CURDIR}${/}bodyJson/body_driver_online.json
    &{headers}=       Create Dictionary      Content-Type=application/json    Authorization=${token}    project-id=${project-id}    company-id=${company-id}
    ${resp4}=         Put Request            api    /v1/mobile/staff/updateStatus    data=${body}    headers=${headers}
    Log               ${resp4}
    Should Be Equal As Strings               ${resp4.status_code}    200

#---------------------Send Notification Driver---------------------------------------------------------------------------------------------------------------
Send Notification & Message
    Create Session    api                    ${url}
    ${body}=          Get Binary File        ${CURDIR}${/}bodyJson/body_send_notification.json
    &{headers}=       Create Dictionary      Content-Type=application/json
    ${resp}=          Post Request           api    /4pl-notification/v1/notification/message    data=${body}    headers=${headers}
    Log               ${resp}
    Should Be Equal As Strings               ${resp.status_code}    200