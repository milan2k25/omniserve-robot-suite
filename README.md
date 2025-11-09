# ClearTrip Robot Framework Automation Project

A comprehensive Robot Framework project for ClearTrip flight search automation with advanced data-driven testing capabilities.

## 🚀 Quick Setup

```bash
git clone https://github.com/yourusername/CleartripRobotFramework.git
cd CleartripRobotFramework
pip install -r requirements.txt
```

## 🎯 Features

- ✅ **Web Automation**: Complete ClearTrip flight search automation
- ✅ **Data-Driven Testing**: Support for JSON, CSV, and Excel data sources
- ✅ **15 Excel Reading Approaches**: From basic to advanced (openpyxl, pandas, RPA Framework, etc.)
- ✅ **Custom Python Library**: Professional Excel reading capabilities
- ✅ **Cross-Platform**: Works on Windows, Linux, and macOS
- ✅ **Professional Structure**: Organized resources, locators, and test cases

## 📁 Project Structure

```
CleartripRobotFramework/
├── testcases/                 # Test case files
│   ├── clearTrip.robot       # Main ClearTrip tests
│   ├── dataTrip.robot        # Data-driven tests
│   └── test_custom_excel.robot
├── resources/                 # Reusable resources
│   ├── resource.robot        # Common keywords and variables
│   └── locator.robot         # Web element locators
├── libraries/                 # Custom Python libraries
│   └── ExcelReader.py        # Custom Excel reading library
├── testdata/                  # Test data files
│   ├── flight_search_data.json
│   ├── flight_search_data.csv
│   └── flight_search_data.xlsx
├── docs/                      # Documentation
├── requirements.txt           # All project dependencies
└── README.md
```

## 🧪 Running Tests

```bash
# Run all tests
robot testcases/

# Run specific test suite
robot testcases/dataTrip.robot

# Run with tags
robot --include data-driven testcases/

# Run tests with custom variables
robot --variable BROWSER:Chrome testcases/clearTrip.robot
```

## 📊 Excel Reading Approaches

This project demonstrates **15 different approaches** for reading Excel files in Robot Framework:

1. **openpyxl** - Primary approach (currently active)
2. **pandas** - Data science approach
3. **RPA Framework** - Professional automation
4. **DataDriver** - Data-driven testing specialist
5. **ExcelLibrary** - Classic Robot Framework
6. **xlrd** - Read-only Excel
7. **PyExcel** - Unified interface
8. **CSV Style** - Simple text-based
9. **Win32COM** - Windows COM interface
10. **Custom Library** - Professional custom implementation
11. **Process Library** - External Python scripts
12. **Tablib** - Multi-format support
13. **HTTP Library** - Web-based Excel files
14. **xlwings** - Excel-Python integration
15. **Database** - Import to DB approach

## 🛠️ Prerequisites

- Python 3.8+
- Web browser (Chrome/Edge)
- Internet connection

## 📋 Key Test Cases

- **Flight Search Functionality**: Automated flight booking flow
- **JSON Data-Driven Tests**: Dynamic test data from JSON files
- **CSV Data-Driven Tests**: Bulk testing with CSV data
- **Excel Data-Driven Tests**: Advanced Excel-based testing
- **Custom Library Demo**: Professional Excel library usage

## 🎓 Learning Resources

- `/docs/Installation_Guide.md` - Complete setup instructions
- `/docs/Excel_Reading_Guide.md` - Guide to all Excel approaches
- `/docs/Custom_Excel_Library_Guide.md` - Custom library documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests to ensure everything works
5. Submit a pull request

## 📞 Support

For setup issues or questions:
1. Check the documentation in `/docs/`
2. Verify Python and pip versions
3. Try using a virtual environment
4. Review error messages for specific package failures

## 📄 License

This project is for educational and learning purposes.

---

**Happy Testing! 🤖✨**