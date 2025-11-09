*** Settings ***
Resource    ../resources/resource.robot
Resource    ../resources/locator.robot
Suite Setup    Open Chrome Browser To Cleartrip
Suite Teardown    Close Browser

*** Test Cases ***

Verify ClearTrip Title
    Verify ClearTrip Home Page Title

Verify ClearTrip Home Page Sections
    Verify Sections In Home Page
Verify Flight Search Functionality
    Search Flights    Bengaluru    GOI

*** Keywords ***

Verify ClearTrip Home Page Title
    ${title}=    Get Title
    Log    ${title}

Verify Flight Section selected

    ${flight_selected}=    Run Keyword And Return Status    Element Should Be Visible    ${FLIGHTS_SECTION_SELECTED}
    Log    ${flight_selected}
    ${flight_sec_present}=    Run Keyword And Return Status    Element Should Be Visible    ${FLIGHTS_SECTION}
    Log    ${flight_sec_present}
    Should Be True    ${flight_selected} or ${flight_sec_present}

    IF    ${flight_selected}
        Log    Flights section is already selected
        Wait Until Element Is Visible    ${SEARCH_FLIGHT_SECTION}    timeout=15s
    ELSE
        Click Element    ${FLIGHTS_SECTION}
        Log    Initially Flight section is not selected, Clicked on it
        Wait Until Element Is Visible    ${SEARCH_FLIGHT_SECTION}    timeout=15s
    END

Verify Hotel Section selected

    ${hotel_selected}=    Run Keyword And Return Status    Element Should Be Visible    ${HOTELS_SECTION_SELECTED}
    Log    ${hotel_selected}
    ${hotel_sec_present}=    Run Keyword And Return Status    Element Should Be Visible    ${HOTELS_SECTION}
    Log    ${hotel_sec_present}
    Should Be True    ${hotel_selected} or ${hotel_sec_present}

    IF    ${hotel_selected}
        Log    Hotels section is already selected
        Wait Until Element Is Visible    ${SEARCH_HOTELS_SECTION}    timeout=15s
    ELSE
        Click Element    ${HOTELS_SECTION}
        Log    Initially Hotel section is not selected, Clicked on it
        Wait Until Element Is Visible    ${SEARCH_HOTELS_SECTION}    timeout=15s
    END
Verify Popup
    ${is_present}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CLOSE_POPUP}    timeout=10s

    IF    ${is_present}
        Click Element    ${CLOSE_POPUP}
        Log    Login Popup is closed
    END
Verify Sections In Home Page
    Verify Popup
    Verify Flight Section selected
    Verify Hotel Section selected
    
    Click Element    ${BUSES_SECTION}
    Log    Clicked on Buses section
    Wait Until Element Is Visible    ${SEARCH_BUSES_SECTION}    timeout=15s
    Go Back
    Wait Until Element Is Visible    ${PACKAGES_SECTION}    timeout=15s
    Click Element    ${PACKAGES_SECTION}
    Log    Clicked on Packages section
    Wait Until Element Is Visible    ${SEARCH_PACKAGES_SECTION}    timeout=15s
    ${package_header}=    Get Text    ${SEARCH_PACKAGES_SECTION}
    Log    ${package_header}
    Go Back

Select Dates
    [Arguments]    ${days_to_add_from}=7    ${days_to_add_to}=14
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${new_date}=    DateTime.Add Time To Date    ${current_date}    ${days_to_add_from} days    result_format=%Y-%m-%d
    ${formatted_date}=    Convert Date    ${new_date}    result_format=%a %b %d %Y
    ${new_date2}=    DateTime.Add Time To Date    ${new_date}    ${days_to_add_to} days    result_format=%Y-%m-%d
    ${formatted_date2}=    Convert Date    ${new_date2}    result_format=%a %b %d %Y

    # Multiple return values approach (commented for future use)
    # [Return]    ${formatted_date}    ${formatted_date2}
    
    # Alternative: List approach (commented for future use)
    # @{date_list}=    Create List    ${formatted_date}    ${formatted_date2}
    # [Return]    ${date_list}
    
    # Dictionary approach - currently active
    &{date_dict}=    Create Dictionary    from_date=${formatted_date}    to_date=${formatted_date2}
    [Return]    ${date_dict}

Search Flights
    Verify Flight Section selected
    [Arguments]    ${from_city_input}    ${to_city_input}
    Verify Popup
    Wait Until Element Is Visible    ${SELECT_WAY_BUTTON}    timeout=10s
    Sleep    1s
    Click Element    ${SELECT_WAY_BUTTON}
    Sleep    1s
    Click Element    ${SELECT_WAY}
    Sleep    1s
    Input Text    ${FROM_CITY}    ${from_city_input}
    Sleep    1s
    Click Element    ${LISTOF_AIRPORT}
    Sleep    1s
    Input Text    ${TO_CITY}    ${to_city_input}
    Sleep    1s
    Click Element    ${LISTOF_AIRPORT}
    Sleep    1s
    
    # Multiple return values approach (commented for future use)
    # ${formatted_date}    ${formatted_date2}=    Select Dates
    
    # Alternative: List approach (commented for future use)
    # @{dates}=    Select Dates
    # ${formatted_date}=    Set Variable    ${dates}[0]
    # ${formatted_date2}=    Set Variable    ${dates}[1]
    
    # Dictionary approach - currently active
    &{dates}=    Select Dates
    ${formatted_date}=    Set Variable    ${dates}[from_date]
    ${formatted_date2}=    Set Variable    ${dates}[to_date]
    
    ${FROM_DATE_LOCATOR}=    Set Variable    //div[@aria-label='${formatted_date}']
    Log    ${FROM_DATE_LOCATOR}
    ${TO_DATE_LOCATOR}=    Set Variable    //div[@aria-label='${formatted_date2}']
    Log    ${TO_DATE_LOCATOR}
    Click Element    ${FROM_DATE_CLR_BTN}
    Sleep    1s
    Click Element    ${FROM_DATE_LOCATOR}
    Sleep    1s
    # Click Element    ${TO_DATE_CLR_BTN}
    # Sleep    1s
    Click Element    ${TO_DATE_LOCATOR}
    Sleep    1s
    Click Element    ${SEARCH_FLIGHT}
    Wait Until Element Is Visible    ${FROM_FLIGHT_RESULT}    timeout=60s
    Log    Flights are showing in the result page
    Capture Page Screenshot    flight_details.png