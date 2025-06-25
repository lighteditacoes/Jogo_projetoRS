@tool
extends EditorScript

# Quick syntax check for test files
# Run this from Tools > Execute Script

func _run():
	print("🔍 Checking test file syntax...")
	
	var test_files = [
		"test/run_all_tests.gd",
		"test/test_plugin.gd",
		"test/test_flexible_boxes.gd",
		"test/verify_plugin.gd"
	]
	
	var all_good = true
	
	for file_path in test_files:
		var script = load("res://" + file_path)
		if script:
			print("✅ ", file_path, " - Syntax OK")
		else:
			print("❌ ", file_path, " - Syntax Error")
			all_good = false
	
	if all_good:
		print("\n🎉 All test files have correct syntax!")
		print("You can now run tests from Tools > Execute Script")
	else:
		print("\n⚠️ Some files have syntax errors - check the output above")
	
	print("\n📝 To run tests:")
	print("1. Tools > Execute Script")
	print("2. Select test file from test/ directory")
	print("3. Click Execute")
