*** Variables ***
##### Endpoint ####
${url}                   https://api.staging.true-e-logistics.com
${headers}               Create Dictionary                                           
${Content-Type}          application/json
${Path_CreateOrder}      /trueryde-delivery/v1/order
${Path_CreateVoucher}    /v1/mobile/

##### Variables Detail ####
${SYSTEM_ADMIN}         ADMIN
${CALL_CENTER}          CALL_CENTER
${COMPANY_ADMIN}        COMPANY_ADMIN
${COMPANY_USER}         COMPANY_USER
${USER}                 USER
