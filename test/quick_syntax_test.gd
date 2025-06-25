@tool
extends EditorScript

# Quick test to verify syntax is correct
# Run this from Tools > Execute Script

func _run():
	print("🔍 Quick Syntax Test")
	print("====================")
	
	# Test loading the main test files
	var test_files = [
		"test/run_all_tests.gd",
		"test/test_plugin.gd"
	]
	
	var all_good = true
	
	for file_path in test_files:
		var script = load("res://" + file_path)
		if script:
			print("✅ ", file_path, " - Loads successfully")
		else:
			print("❌ ", file_path, " - Failed to load")
			all_good = false
	
	if all_good:
		print("\n🎉 All test files have correct syntax!")
		print("\n📝 You can now run:")
		print("• test/test_plugin.gd - Quick plugin test")
		print("• test/run_all_tests.gd - Run multiple tests")
		print("• test/test_flexible_boxes.gd - Test latest features")
	else:
		print("\n⚠️ Some files still have syntax errors")
	
	print("\n✅ Syntax test completed!")
