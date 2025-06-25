@tool
extends EditorScript

# Test script to verify the AI Coding Assistant plugin is working
# Run this script from Tools > Execute Script

func _run():
	print("Testing AI Coding Assistant Plugin...")

	# Check if plugin files exist
	var plugin_path = "res://addons/ai_coding_assistant/"
	var required_files = [
		"plugin.cfg",
		"plugin.gd",
		"ai_assistant_dock.gd",
		"ai_api_manager.gd",
		"code_analyzer.gd",
		"diff_viewer.gd",
		"settings_dialog.gd",
		"setup_guide.gd"
	]

	print("Checking plugin files...")
	var all_files_exist = true

	for file in required_files:
		var file_path = plugin_path + file
		if FileAccess.file_exists(file_path):
			print("✓ Found: " + file)
		else:
			print("✗ Missing: " + file)
			all_files_exist = false

	# Test loading the main classes
	print("\nTesting script loading...")
	var loading_success = true

	var plugin_script = load("res://addons/ai_coding_assistant/plugin.gd")
	if plugin_script:
		print("✓ Plugin script loads successfully")
	else:
		print("✗ Failed to load plugin script")
		loading_success = false

	var dock_script = load("res://addons/ai_coding_assistant/ai_assistant_dock.gd")
	if dock_script:
		print("✓ Dock script loads successfully")
	else:
		print("✗ Failed to load dock script")
		loading_success = false

	var api_script = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	if api_script:
		print("✓ API manager script loads successfully")
	else:
		print("✗ Failed to load API manager script")
		loading_success = false

	if all_files_exist and loading_success:
		print("\n✅ All plugin files are present and loadable!")
		print("\nNext steps:")
		print("1. Enable the plugin in Project Settings > Plugins")
		print("2. Look for the 'AI Assistant' dock on the left side")
		print("3. Click the '?' button for setup guide")
		print("4. Configure your API key and start coding with AI!")
	else:
		print("\n❌ Some issues found. Please check the installation.")

	print("\nPlugin test completed.")
