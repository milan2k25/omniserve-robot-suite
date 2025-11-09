*** Settings ***
Resource    ../resources/resource.robot
Resource    ../resources/locator.robot

*** Test Cases ***
Fetch Current Directory
    Get Current Directory

String Addition
    String Concatenate

Even Odd Number Check
    Program to Get Even Odd Number    10
    Program to Get Even Odd Number    7

*** Keywords ***
Get Current Directory
    Log    ${WORKING_DIR}

String Concatenate
    ${FULL_URL}=    Catenate    SEPARATOR=?    ${requested_url}    ${endpoint}
    Log    ${FULL_URL}

Program to Get Even Odd Number
    [Arguments]    ${num}
    IF    ${num}%2==0
        Log    Number is Even
    ELSE
        Log    Number is Odd
    END

Print String using For Loop
    [Arguments]    ${value}
    FOR    ${i}    IN RANGE    6
        Log    ${value}
        
    END