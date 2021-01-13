*** Settings ***
Resource    ../global_resource.robot
Resource    ../users_keyword.robot

*** Test Cases ***
Send Notification Driver
    Send Notification & Message Driver
Send Notification Passenger
    Send Notification & Message Passenger