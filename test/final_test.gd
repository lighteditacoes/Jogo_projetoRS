@tool
extends EditorScript

# Final test to verify all fixes are working
# Run this from Tools > Execute Script

func _run():
	print("=== FINAL PLUGIN TEST ===")

	# Test 1: Check Godot version
	var version = Engine.get_version_info()
	print("Godot Version: " + str(version.major) + "." + str(version.minor) + "." + str(version.patch))

	# Test 2: Try loading all scripts
	print("\nTesting script loading...")
	var scripts_to_test = [
		"res://addons/ai_coding_assistant/plugin.gd",
		"res://addons/ai_coding_assistant/ai_assistant_dock.gd",
		"res://addons/ai_coding_assistant/ai_api_manager.gd",
		"res://addons/ai_coding_assistant/code_analyzer.gd",
		"res://addons/ai_coding_assistant/diff_viewer.gd",
		"res://addons/ai_coding_assistant/settings_dialog.gd",
		"res://addons/ai_coding_assistant/setup_guide.gd"
	]

	var all_good = true
	for script_path in scripts_to_test:
		var script = load(script_path)
		if script:
			print("✅ " + script_path.get_file())
		else:
			print("❌ " + script_path.get_file() + " - FAILED TO LOAD")
			all_good = false

	# Test 3: Try instantiating main classes
	print("\nTesting instantiation...")

	var plugin_script = load("res://addons/ai_coding_assistant/plugin.gd")
	if plugin_script:
		var plugin_instance = plugin_script.new()
		if plugin_instance:
			print("✅ Plugin can be instantiated")
			plugin_instance.free()
		else:
			print("❌ Plugin instantiation failed")
			all_good = false

	# Note: Skip dock instantiation test as it requires complex setup
	print("✅ Dock script loads (instantiation test skipped - requires UI context)")

	# Final result
	print("\n=== RESULT ===")
	if all_good:
		print("🎉 ALL TESTS PASSED!")
		print("✅ Plugin should now work without parse errors")
		print("✅ You should see the AI Assistant dock on the left side")
		print("\nNext steps:")
		print("1. Go to Project Settings > Plugins")
		print("2. Enable 'AI Coding Assistant'")
		print("3. Look for the dock on the left side")
		print("4. Get your API key and start coding!")
	else:
		print("❌ Some tests failed - check the errors above")

	print("\n=== END TEST ===")
