*** Settings ***
Resource    resource/global_resource.robot
Resource    resource/driver_keyword.robot

*** Test Cases ***
Create Order TrueRyde Driver Staging
    Create Order
    Sleep    10
Cancel TrueRyde Driver Staging
    Cancel Order