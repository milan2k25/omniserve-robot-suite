*** Settings ***
Library    String
Library    DateTime
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    ../libraries/ExcelReader.py

*** Variables ***
${URL}    https://cleartrip.com
${BROWSER_NAME}    Edge
${REQUESTED_URL}    https://example.com
${ENDPOINT}    /api/users
${TEST_DATA_DIR}    ${CURDIR}${/}..${/}testdata
${WORKING_DIR}    ${CURDIR}

*** Keywords ***
Open Chrome Browser To Cleartrip
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --incognito
    Open Browser    ${URL}    ${BROWSER_NAME}    options=${options}
    Maximize Browser Window
    Sleep    2s

Open Edge Browser To Cleartrip
    ${edge_options}=    Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys, selenium.webdriver
    Call Method    ${edge_options}    add_argument    --inprivate
    Create Webdriver    ${BROWSER_NAME}    options=${edge_options}
    Go To    ${URL}
    # Open Browser    ${URL}    ${BROWSER_NAME}    options=${edge_options}
    Maximize Browser Window
    Sleep    2s