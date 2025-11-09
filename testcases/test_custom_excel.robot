*** Settings ***
Documentation    Test file to demonstrate custom Excel library usage
Resource    ../resources/resource.robot
Resource    ../resources/locator.robot
Resource    dataTrip.robot

*** Test Cases ***

Test Custom Excel Library Basic
    [Documentation]    Test basic functionality of custom Excel library
    [Tags]    custom-library    excel    demo
    
    # Test basic read functionality
    ${excel_data}=    Read Excel Data    ${TEST_DATA_DIR}${/}flight_search_data.xlsx
    Log    ${excel_data}
    
    # Verify data structure
    ${data_count}=    Get Length    ${excel_data}
    Should Be True    ${data_count} > 0    No data found in Excel file
    
    # Check first record structure
    ${first_record}=    Get From List    ${excel_data}    0
    Should Contain    ${first_record}    test_name
    Should Contain    ${first_record}    from_city
    Should Contain    ${first_record}    to_city
    
    Log    Custom Excel library test passed!

Test Custom Excel Library Advanced
    [Documentation]    Test advanced functionality of custom Excel library
    [Tags]    custom-library    excel    advanced
    
    # Get sheet names
    ${sheet_names}=    Get Excel Sheet Names    ${TEST_DATA_DIR}${/}flight_search_data.xlsx
    Log    Available sheets: ${sheet_names}
    
    # Validate file structure
    @{expected_columns}=    Create List    test_name    from_city    to_city    expected_result    description
    ${is_valid}=    Validate Excel File Structure    ${TEST_DATA_DIR}${/}flight_search_data.xlsx    ${expected_columns}
    Should Be True    ${is_valid}    Excel file structure validation failed
    
    # Read with pandas
    ${excel_data}=    Read Excel Data With Pandas    ${TEST_DATA_DIR}${/}flight_search_data.xlsx
    Log    Data from pandas: ${excel_data}
    
    # Read specific cell
    ${cell_value}=    Read Excel Cell Value    ${TEST_DATA_DIR}${/}flight_search_data.xlsx    2    1
    Log    Cell value at row 2, column 1: ${cell_value}
    
    Log    Advanced custom Excel library test passed!

Test Custom Excel Library Integration
    [Documentation]    Test custom library integration with existing test flow
    [Tags]    custom-library    integration    flight-search
    
    # Load data using custom library
    ${excel_data}=    Load Excel Test Data Custom    flight_search_data.xlsx
    
    # Use the data in a loop (similar to main test)
    FOR    ${test_case}    IN    @{excel_data}
        Log    Test case: ${test_case}[test_name]
        Log    From: ${test_case}[from_city] To: ${test_case}[to_city]
        Log    Expected result: ${test_case}[expected_result]
        # In real scenario, you would call Search Flights here
    END
    
    Log    Custom Excel library integration test passed!

*** Keywords ***
# You can add custom keywords here that use the Excel library