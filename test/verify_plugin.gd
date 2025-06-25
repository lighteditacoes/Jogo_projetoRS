@tool
extends EditorScript

# Simple verification script to test plugin loading
# Run this from Tools > Execute Script

func _run():
	print("=== AI Coding Assistant Plugin Verification ===")

	# Test 1: Check if files exist
	print("\n1. Checking plugin files...")
	var plugin_files = [
		"res://addons/ai_coding_assistant/plugin.cfg",
		"res://addons/ai_coding_assistant/plugin.gd",
		"res://addons/ai_coding_assistant/ai_assistant_dock.gd",
		"res://addons/ai_coding_assistant/ai_api_manager.gd"
	]

	var files_ok = true
	for file_path in plugin_files:
		if FileAccess.file_exists(file_path):
			print("   ✓ " + file_path)
		else:
			print("   ✗ " + file_path + " - MISSING!")
			files_ok = false

	# Test 2: Try loading scripts
	print("\n2. Testing script loading...")
	var scripts_ok = true

	var plugin_script = load("res://addons/ai_coding_assistant/plugin.gd")
	if plugin_script:
		print("   ✓ plugin.gd loads successfully")
		# Test instantiation
		var plugin_instance = plugin_script.new()
		if plugin_instance:
			print("   ✓ plugin.gd can be instantiated")
			plugin_instance.free()
		else:
			print("   ✗ plugin.gd cannot be instantiated")
			scripts_ok = false
	else:
		print("   ✗ plugin.gd failed to load")
		scripts_ok = false

	var dock_script = load("res://addons/ai_coding_assistant/ai_assistant_dock.gd")
	if dock_script:
		print("   ✓ ai_assistant_dock.gd loads successfully")
	else:
		print("   ✗ ai_assistant_dock.gd failed to load")
		scripts_ok = false

	var api_script = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	if api_script:
		print("   ✓ ai_api_manager.gd loads successfully")
	else:
		print("   ✗ ai_api_manager.gd failed to load")
		scripts_ok = false

	# Test 3: Check plugin.cfg
	print("\n3. Checking plugin configuration...")
	var config = ConfigFile.new()
	var err = config.load("res://addons/ai_coding_assistant/plugin.cfg")
	if err == OK:
		var plugin_name = config.get_value("plugin", "name", "")
		var plugin_script_path = config.get_value("plugin", "script", "")
		print("   ✓ Plugin name: " + plugin_name)
		print("   ✓ Plugin script: " + plugin_script_path)
	else:
		print("   ✗ Failed to load plugin.cfg")
		scripts_ok = false

	# Final result
	print("\n=== VERIFICATION RESULT ===")
	if files_ok and scripts_ok:
		print("✅ SUCCESS! Plugin is ready to use.")
		print("\n🎉 All parse errors have been fixed!")
		print("\nNext steps:")
		print("1. Go to Project Settings > Plugins")
		print("2. Enable 'AI Coding Assistant'")
		print("3. Look for the AI Assistant dock on the left")
		print("4. Get your free API key and start coding!")
	else:
		print("❌ ISSUES FOUND! Please check the errors above.")

	print("\n=== END VERIFICATION ===")
