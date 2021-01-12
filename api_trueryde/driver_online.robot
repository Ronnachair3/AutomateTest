*** Settings ***
Resource    resource/global_resource.robot
Resource    resource/driver_keyword.robot

*** Test Cases ***
Driver Login & Online
    Login Driver
    Driver Vehicle List
    Driver Set Active Vehicle
    Driver Online