*** Settings ***
Resource    resource/global_resource.robot
Resource    resource/custom_keyword.robot

*** Test Cases ***
Send Notification Driver
    Send Notification & Message