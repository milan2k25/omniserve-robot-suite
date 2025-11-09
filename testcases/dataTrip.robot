*** Settings ***
Documentation    Data-driven testing for Cleartrip flight search functionality
Resource    ../resources/resource.robot
Resource    ../resources/locator.robot
Resource    clearTrip.robot
Suite Setup    Open Chrome Browser To Cleartrip
Suite Teardown    Close Browser

*** Test Cases ***

# JSON Data-Driven Flight Search Test
Search Flights Using JSON Data
    [Documentation]    Test flight search functionality using JSON test data
    [Tags]    data-driven    json    flight-search
    ${json_data}=    Load JSON Test Data    flight_search_data.json
    FOR    ${test_case}    IN    @{json_data}
        Log    Testing with data: ${test_case}
        Search Flights With Test Data    ${test_case}
        Sleep    2s
        Go To    ${URL}
        Sleep    2s
    END

# CSV Data-Driven Flight Search Test
Search Flights Using CSV Data
    [Documentation]    Test flight search functionality using CSV test data
    [Tags]    data-driven    csv    flight-search
    @{csv_data}=    Load CSV Test Data    flight_search_data.csv
    FOR    ${test_case}    IN    @{csv_data}
        Log    Testing with data: ${test_case}
        Search Flights With CSV Data    ${test_case}
        Sleep    2s
        Go To    ${URL}
        Sleep    2s
    END

# Excel Data-Driven Flight Search Test
Search Flights Using Excel Data
    [Documentation]    Test flight search functionality using Excel test data
    [Tags]    data-driven    excel    flight-search
    ${excel_data}=    Load Excel Test Data    flight_search_data.xlsx
    FOR    ${test_case}    IN    @{excel_data}
        Log    Testing with data: ${test_case}
        Search Flights With Excel Data    ${test_case}
        Sleep    2s
        Go To    ${URL}
        Sleep    2s
    END

*** Keywords ***

Load JSON Test Data
    [Documentation]    Load test data from JSON file
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    ${json_string}=    Get File    ${file_path}
    ${json_data}=    Evaluate    json.loads('''${json_string}''')    json
    [Return]    ${json_data}

Load CSV Test Data
    [Documentation]    Load test data from CSV file
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    ${csv_content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${csv_content}
    ${header}=    Get From List    ${lines}    0
    @{header_list}=    Split String    ${header}    ,
    @{test_data}=    Create List
    
    FOR    ${index}    IN RANGE    1    ${lines.__len__()}
        ${line}=    Get From List    ${lines}    ${index}
        @{values}=    Split String    ${line}    ,
        &{test_case}=    Create Dictionary
        FOR    ${col_index}    IN RANGE    ${header_list.__len__()}
            ${key}=    Get From List    ${header_list}    ${col_index}
            ${value}=    Get From List    ${values}    ${col_index}
            Set To Dictionary    ${test_case}    ${key}    ${value}
        END
        Append To List    ${test_data}    ${test_case}
    END
    [Return]    ${test_data}

Load Excel Test Data
    [Documentation]    Load test data from Excel file - Multiple approaches available
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # APPROACH 1: Using Python openpyxl (Currently Active)
    ${excel_data_raw}=    Evaluate    
    ...    __import__('openpyxl').load_workbook(r'${file_path}').active
    
    ${headers}=    Evaluate    
    ...    [cell.value for cell in list($excel_data_raw.iter_rows(min_row=1, max_row=1))[0]]
    
    ${rows_data}=    Evaluate    
    ...    [[cell.value for cell in row] for row in list($excel_data_raw.iter_rows(min_row=2))]
    
    # Convert to Robot Framework format
    @{excel_data}=    Create List
    FOR    ${row_values}    IN    @{rows_data}
        &{test_case}=    Create Dictionary
        FOR    ${index}    IN RANGE    ${headers.__len__()}
            ${key}=    Get From List    ${headers}    ${index}
            ${value}=    Get From List    ${row_values}    ${index}
            Set To Dictionary    ${test_case}    ${key}    ${value}
        END
        Append To List    ${excel_data}    ${test_case}
    END
    
    [Return]    ${excel_data}

# APPROACH 2: RPA Framework (Professional Grade)
Load Excel Test Data RPA
    [Documentation]    Using RPA.Excel.Files library (pip install rpaframework)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Open Workbook    ${file_path}
    # ${excel_data}=    Read Worksheet As Table    header=True
    # Close Workbook
    # [Return]    ${excel_data}
    
    # For now, simulate RPA approach
    Log    RPA Framework approach - install: pip install rpaframework
    ${excel_data}=    Create List
    [Return]    ${excel_data}

# APPROACH 3: Pandas Library (Data Science Approach) 
Load Excel Test Data Pandas
    [Documentation]    Using pandas library (pip install pandas openpyxl)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Using pandas - very powerful for data manipulation
    ${excel_data}=    Evaluate    
    ...    __import__('pandas').read_excel(r'${file_path}').fillna('').to_dict('records')
    
    [Return]    ${excel_data}

# APPROACH 4: DataDriver Library (Data-Driven Testing Specialist)
Load Excel Test Data DataDriver
    [Documentation]    Using DataDriver library (pip install robotframework-datadriver)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # DataDriver automatically handles Excel files in test templates
    # This would be used at test suite level, not keyword level
    Log    DataDriver approach - use in Test Template
    ${excel_data}=    Create List
    [Return]    ${excel_data}

# APPROACH 5: ExcelLibrary (Classic Robot Framework)
Load Excel Test Data ExcelLibrary
    [Documentation]    Using ExcelLibrary (pip install robotframework-excellibrary)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Open Excel    ${file_path}
    # ${excel_data}=    Read Excel File
    # Close Excel
    # [Return]    ${excel_data}
    
    Log    ExcelLibrary approach - install: pip install robotframework-excellibrary
    ${excel_data}=    Create List
    [Return]    ${excel_data}

# APPROACH 6: xlrd Library (Read-only Excel)
Load Excel Test Data XLRD
    [Documentation]    Using xlrd library (pip install xlrd)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    ${excel_data}=    Evaluate    
    ...    [dict(zip([sheet.cell_value(0, col) for col in range(sheet.ncols)], [sheet.cell_value(row, col) for col in range(sheet.ncols)])) for row in range(1, sheet.nrows)] if (book := __import__('xlrd').open_workbook(r'${file_path}')) and (sheet := book.sheet_by_index(0)) else []
    
    [Return]    ${excel_data}

# APPROACH 7: PyExcel Library (Unified Interface)
Load Excel Test Data PyExcel
    [Documentation]    Using pyexcel library (pip install pyexcel pyexcel-xlsx)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    ${excel_data}=    Evaluate    
    ...    __import__('pyexcel').get_records(file_name=r'${file_path}')
    
    [Return]    ${excel_data}

# APPROACH 8: CSV Treatment (Simple)
Load Excel Test Data CSV_Style
    [Documentation]    Treating Excel as CSV file (works if Excel is in CSV format)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    ${excel_content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${excel_content}
    ${header}=    Get From List    ${lines}    0
    @{header_list}=    Split String    ${header}    ,
    @{excel_data}=    Create List
    
    FOR    ${index}    IN RANGE    1    ${lines.__len__()}
        ${line}=    Get From List    ${lines}    ${index}
        @{values}=    Split String    ${line}    ,
        &{test_case}=    Create Dictionary
        FOR    ${col_index}    IN RANGE    ${header_list.__len__()}
            ${key}=    Get From List    ${header_list}    ${col_index}
            ${value}=    Get From List    ${values}    ${col_index}
            ${clean_key}=    Strip String    ${key}
            ${clean_value}=    Strip String    ${value}
            Set To Dictionary    ${test_case}    ${clean_key}    ${clean_value}
        END
        Append To List    ${excel_data}    ${test_case}
    END
    
    [Return]    ${excel_data}

# APPROACH 9: Win32com (Windows COM Interface)
Load Excel Test Data Win32COM
    [Documentation]    Using Windows COM interface (pip install pywin32)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    ${excel_data}=    Evaluate    
    ...    [dict(zip([ws.Cells(1, col).Value for col in range(1, ws.UsedRange.Columns.Count + 1)], [ws.Cells(row, col).Value for col in range(1, ws.UsedRange.Columns.Count + 1)])) for row in range(2, ws.UsedRange.Rows.Count + 1)] if (xl := __import__('win32com.client').Dispatch('Excel.Application')) and (wb := xl.Workbooks.Open(r'${file_path}')) and (ws := wb.ActiveSheet) and xl.Quit() == None else []
    
    [Return]    ${excel_data}

# APPROACH 10: Custom Python Library
Load Excel Test Data Custom
    [Documentation]    Using custom Python library approach
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Method 1: Using basic read excel data keyword
    ${excel_data}=    Read Excel Data    ${file_path}
    [Return]    ${excel_data}
    
    # Method 2: Using pandas-based keyword (alternative)
    # ${excel_data}=    Read Excel Data With Pandas    ${file_path}
    # [Return]    ${excel_data}
    
    # Method 3: Reading specific sheet
    # ${excel_data}=    Read Excel Sheet By Name    ${file_path}    Sheet1
    # [Return]    ${excel_data}

# Additional Custom Library Keywords for Advanced Usage
Load Excel Test Data Custom Advanced
    [Documentation]    Advanced usage of custom library with validation
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Validate file structure first
    @{expected_columns}=    Create List    test_name    from_city    to_city    expected_result    description
    ${is_valid}=    Validate Excel File Structure    ${file_path}    ${expected_columns}
    Should Be True    ${is_valid}    Excel file structure is not valid
    
    # Get sheet names
    ${sheet_names}=    Get Excel Sheet Names    ${file_path}
    Log    Available sheets: ${sheet_names}
    
    # Read data using pandas method
    ${excel_data}=    Read Excel Data With Pandas    ${file_path}
    
    # Log data count
    ${data_count}=    Get Length    ${excel_data}
    Log    Loaded ${data_count} test cases from Excel file
    
    [Return]    ${excel_data}

# APPROACH 11: Robot Framework Process Library + Python Script
Load Excel Test Data Process
    [Documentation]    Using Process library to call external Python script
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Create external Python script and call it using Process library
    # Run Process    python    excel_reader.py    ${file_path}
    # ${result}=    Get Process Result
    # ${excel_data}=    Evaluate    json.loads('${result.stdout}')    json
    
    Log    Process library approach - call external Python script
    ${excel_data}=    Create List
    [Return]    ${excel_data}

# APPROACH 12: Using tablib Library
Load Excel Test Data Tablib
    [Documentation]    Using tablib library (pip install tablib[xlsx])
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    ${excel_data}=    Evaluate    
    ...    __import__('tablib').Dataset().load(open(r'${file_path}', 'rb').read(), format='xlsx').dict
    
    [Return]    ${excel_data}

# APPROACH 13: HTTP Library (for Excel files from URLs)
Load Excel Test Data HTTP
    [Documentation]    For reading Excel files from web URLs
    [Arguments]    ${url}
    
    # GET    ${url}    headers={'Accept': 'application/vnd.ms-excel'}
    # ${excel_data}=    Evaluate    pandas.read_excel(io.BytesIO(response.content)).to_dict('records')
    
    Log    HTTP library approach - for Excel files from web
    ${excel_data}=    Create List
    [Return]    ${excel_data}

# APPROACH 14: Using xlwings Library (Excel + Python Integration)
Load Excel Test Data XLWings
    [Documentation]    Using xlwings library (pip install xlwings)
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    ${excel_data}=    Evaluate    
    ...    [dict(zip(sht.range('A1').expand('right').value, row)) for row in sht.range('A2').expand().value] if (app := __import__('xlwings').App(visible=False)) and (wb := app.books.open(r'${file_path}')) and (sht := wb.sheets[0]) and wb.close() and app.quit() == None else []
    
    [Return]    ${excel_data}

# APPROACH 15: Database Approach (Import Excel to DB first)
Load Excel Test Data Database
    [Documentation]    Import Excel to database then read from DB
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Import Excel to SQLite/PostgreSQL/MySQL first
    # Then use DatabaseLibrary to read
    # Connect To Database    ...
    # ${excel_data}=    Query    SELECT * FROM test_data
    
    Log    Database approach - import Excel to DB first
    ${excel_data}=    Create List
    [Return]    ${excel_data}

# Alternative Method using Robot Framework Excel Library (if available)
Load Excel Test Data Alternative
    [Documentation]    Alternative method using robot framework libraries
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Method 2: Using Python pandas (if available)
    ${excel_data}=    Evaluate    
    ...    __import__('pandas').read_excel('${file_path}').to_dict('records')
    ...    modules=pandas
    
    [Return]    ${excel_data}

# Method 3: Simple CSV-like approach (current Excel file is CSV format)
Load Excel Test Data Simple
    [Documentation]    Simple approach treating Excel as CSV
    [Arguments]    ${filename}
    ${file_path}=    Set Variable    ${TEST_DATA_DIR}${/}${filename}
    
    # Since your Excel file is in CSV format, read as CSV
    ${excel_content}=    Get File    ${file_path}
    @{lines}=    Split To Lines    ${excel_content}
    ${header}=    Get From List    ${lines}    0
    @{header_list}=    Split String    ${header}    ,
    @{excel_data}=    Create List
    
    FOR    ${index}    IN RANGE    1    ${lines.__len__()}
        ${line}=    Get From List    ${lines}    ${index}
        # Handle potential commas in values by using a more robust split
        @{values}=    Split String    ${line}    ,
        &{test_case}=    Create Dictionary
        FOR    ${col_index}    IN RANGE    ${header_list.__len__()}
            ${key}=    Get From List    ${header_list}    ${col_index}
            ${value}=    Get From List    ${values}    ${col_index}
            # Clean up any extra whitespace
            ${clean_key}=    Strip String    ${key}
            ${clean_value}=    Strip String    ${value}
            Set To Dictionary    ${test_case}    ${clean_key}    ${clean_value}
        END
        Append To List    ${excel_data}    ${test_case}
    END
    
    [Return]    ${excel_data}

Search Flights With Test Data
    [Documentation]    Search flights using JSON test data
    [Arguments]    ${test_data}
    Log    Executing test: ${test_data}[test_name]
    Log    From: ${test_data}[from_city] To: ${test_data}[to_city]
    
    # Call the existing Search Flights keyword with dictionary data
    Search Flights    ${test_data}[from_city]    ${test_data}[to_city]
    
    # Add validation based on expected result
    Run Keyword If    '${test_data}[expected_result]' == 'success'    
    ...    Validate Flight Search Success
    ...    ELSE    Validate Flight Search Failure

Search Flights With CSV Data
    [Documentation]    Search flights using CSV test data
    [Arguments]    ${test_data}
    Log    Executing CSV test: ${test_data}[test_name]
    Log    From: ${test_data}[from_city] To: ${test_data}[to_city]
    
    Search Flights    ${test_data}[from_city]    ${test_data}[to_city]
    
    Run Keyword If    '${test_data}[expected_result]' == 'success'    
    ...    Validate Flight Search Success
    ...    ELSE    Validate Flight Search Failure

Search Flights With Excel Data
    [Documentation]    Search flights using Excel test data
    [Arguments]    ${test_data}
    Log    Executing Excel test: ${test_data}[test_name]
    Log    From: ${test_data}[from_city] To: ${test_data}[to_city]
    
    Search Flights    ${test_data}[from_city]    ${test_data}[to_city]
    
    Run Keyword If    '${test_data}[expected_result]' == 'success'    
    ...    Validate Flight Search Success
    ...    ELSE    Validate Flight Search Failure

Validate Flight Search Success
    [Documentation]    Validate that flight search was successful
    Wait Until Element Is Visible    ${FROM_FLIGHT_RESULT}    timeout=30s
    Log    Flight search completed successfully
    Capture Page Screenshot    flight_search_success.png

Validate Flight Search Failure
    [Documentation]    Validate expected failure scenarios
    Log    Validating expected failure scenario
    # Add specific failure validations here