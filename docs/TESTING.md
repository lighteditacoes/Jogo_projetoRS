# 🧪 AI Coding Assistant - Test Suite

This directory contains all test scripts for the AI Coding Assistant plugin. These scripts help verify functionality, debug issues, and ensure everything works correctly.

## 📋 Test Files Overview

### Core Plugin Tests
- **`verify_fixes.gd`** - Verify all syntax fixes are working (run this first!)
- **`quick_syntax_test.gd`** - Quick syntax verification for test files
- **`test_plugin.gd`** - Main plugin functionality test
- **`verify_plugin.gd`** - Comprehensive plugin verification
- **`final_test.gd`** - Final integration test for all features
- **`run_all_tests.gd`** - Test runner to execute multiple tests

### API & Connection Tests
- **`test_gemini_api.gd`** - Test Gemini API connectivity
- **`test_gemini_2_flash.gd`** - Test Gemini 2.0 Flash model specifically
- **`test_available_models.gd`** - Check available AI models
- **`simple_api_test.gd`** - Basic API connection test
- **`test_api_manager_fix.gd`** - API manager functionality test

### UI & Interface Tests
- **`test_resizable_dock.gd`** - Test resizable dock functionality
- **`test_enhanced_features.gd`** - Test enhanced selection & copy features
- **`test_flexible_boxes.gd`** - Test flexible chat/code boxes (latest)
- **`test_input_field.gd`** - Debug input field issues

### Debug & Diagnostic Tests
- **`debug_api_manager.gd`** - Debug API manager initialization
- **`check_version.gd`** - Check Godot version compatibility

## 🚀 How to Run Tests

### Method 1: From Godot Editor
1. Open Godot with the AI Coding Assistant project
2. Go to **Tools > Execute Script**
3. Select the test file you want to run
4. Click **Execute**

### Method 2: From Script Editor
1. Open any test file in the script editor
2. Click the **Execute** button (▶) in the toolbar
3. View results in the output panel

## 📊 Test Categories

### 🔧 **Setup & Installation Tests**
Run these first to ensure basic functionality:
```
1. verify_fixes.gd         - Verify syntax fixes (START HERE!)
2. quick_syntax_test.gd    - Quick syntax verification
3. test_plugin.gd          - Basic plugin loading
4. verify_plugin.gd        - Comprehensive verification
5. check_version.gd        - Version compatibility
```

### 🌐 **API Connection Tests**
Test AI provider connectivity:
```
1. simple_api_test.gd      - Basic connection
2. test_gemini_api.gd      - Gemini API specific
3. test_gemini_2_flash.gd  - Latest model test
4. test_available_models.gd - Model availability
```

### 🎨 **UI Feature Tests**
Test interface functionality:
```
1. test_resizable_dock.gd     - Resizable interface
2. test_enhanced_features.gd  - Selection & copy features
3. test_flexible_boxes.gd     - Latest flexible boxes
4. test_input_field.gd        - Input field debugging
```

### 🔍 **Debug & Troubleshooting**
For when things go wrong:
```
1. debug_api_manager.gd    - API manager issues
2. test_api_manager_fix.gd - API manager fixes
3. final_test.gd           - Complete system test
```

## ✅ Expected Test Results

### Successful Test Output
```
=== Testing [Feature Name] ===
✅ Feature loads successfully
✅ All components initialized
✅ Functionality working correctly
🎉 Test completed successfully!
```

### Failed Test Output
```
=== Testing [Feature Name] ===
❌ Failed to load component
⚠️ Warning: Feature may need attention
🔧 Check the errors above for details
```

## 🐛 Troubleshooting Tests

### If Tests Fail
1. **Check Godot Version**: Run `check_version.gd`
2. **Verify Plugin**: Run `verify_plugin.gd`
3. **Test API**: Run `simple_api_test.gd`
4. **Debug Specific**: Run relevant debug script

### Common Issues
- **Plugin not enabled**: Enable in Project Settings > Plugins
- **API key missing**: Set API key in AI Assistant dock
- **Version mismatch**: Check Godot 4.x compatibility
- **Network issues**: Test internet connection

## 📈 Test Development

### Adding New Tests
1. Create new `.gd` file in `test/` directory
2. Extend `EditorScript` class
3. Implement `_run()` function
4. Add descriptive print statements
5. Update this README

### Test Template
```gdscript
@tool
extends EditorScript

# Test script for [Feature Name]
# Run this from Tools > Execute Script

func _run():
    print("=== Testing [Feature Name] ===")

    # Test implementation here

    print("✅ Test completed!")
```

## 🎯 Test Coverage

### Current Coverage
- ✅ Plugin loading and initialization
- ✅ API connectivity and authentication
- ✅ UI components and resizing
- ✅ Enhanced features (selection, copy, etc.)
- ✅ Flexible boxes and markdown
- ✅ Error handling and debugging

### Future Tests
- 🔄 Performance testing
- 🔄 Memory usage testing
- 🔄 Cross-platform compatibility
- 🔄 Automated test runner

## 📝 Test Results Log

Keep track of your test results:
- **Date**: [Date]
- **Godot Version**: [Version]
- **Tests Passed**: [Number]
- **Tests Failed**: [Number]
- **Notes**: [Any observations]

## 🎉 Happy Testing!

These tests ensure the AI Coding Assistant works perfectly for all users. Run them regularly during development and after updates to catch any issues early!

For more information, check the main README.md in the project root.
