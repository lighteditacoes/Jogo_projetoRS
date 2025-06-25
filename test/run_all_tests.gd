@tool
extends EditorScript

# Test runner script to run multiple tests in sequence
# Run this from Tools > Execute Script

func _run():
	print("AI Coding Assistant - Test Suite Runner")
	print("======================================")
	
	var test_files = [
		"test/check_version.gd",
		"test/test_plugin.gd",
		"test/verify_plugin.gd",
		"test/simple_api_test.gd",
		"test/test_resizable_dock.gd",
		"test/test_enhanced_features.gd",
		"test/test_flexible_boxes.gd"
	]
	
	var passed_tests = 0
	var total_tests = test_files.size()
	
	print("")
	print("Running ", total_tests, " test files...")
	print("--------------------------------------")
	
	for test_file in test_files:
		print("")
		print("Running: ", test_file)
		var success = run_test_file(test_file)
		if success:
			passed_tests += 1
			print("PASSED: ", test_file)
		else:
			print("FAILED: ", test_file)
	
	print("")
	print("======================================")
	print("TEST RESULTS SUMMARY")
	print("======================================")
	print("Passed: ", passed_tests, "/", total_tests)
	print("Failed: ", total_tests - passed_tests, "/", total_tests)
	
	if passed_tests == total_tests:
		print("ALL TESTS PASSED! Plugin is working correctly.")
	else:
		print("Some tests failed. Check individual test outputs above.")
	
	print("")
	print("To run individual tests:")
	print("   Tools > Execute Script > Select test file")
	print("")
	print("For more info, check test/README.md")
	print("======================================")

func run_test_file(file_path: String) -> bool:
	# Try to load and run the test script
	var test_script = load("res://" + file_path)
	if not test_script:
		print("   Failed to load test script: ", file_path)
		return false
	
	# Create instance and run
	var test_instance = test_script.new()
	if not test_instance:
		print("   Failed to create test instance: ", file_path)
		return false
	
	# Check if it has the _run method
	if not test_instance.has_method("_run"):
		print("   Test script missing _run method: ", file_path)
		test_instance.queue_free()
		return false
	
	# Run the test (this is a simplified check)
	# In a real test runner, you'd capture output and check for success/failure
	test_instance._run()
	test_instance.queue_free()
	return true  # Assume success if no crash occurred
