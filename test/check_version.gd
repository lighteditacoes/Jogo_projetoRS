@tool
extends EditorScript

# Version compatibility checker and auto-fixer
# Run this from Tools > Execute Script

func _run():
	print("=== Godot Version Compatibility Checker ===")

	# Get Godot version
	var version = Engine.get_version_info()
	var version_string = str(version.major) + "." + str(version.minor) + "." + str(version.patch)

	print("\n🔍 Detected Godot Version: " + version_string)

	if version.major >= 4:
		print("✅ Godot 4.x detected!")
		print("✅ Plugin should work perfectly with current syntax")
		_check_godot4_compatibility()
	elif version.major == 3:
		print("⚠️ Godot 3.x detected!")
		print("⚠️ Plugin may need syntax adjustments")
		_check_godot3_compatibility()
	else:
		print("❌ Unsupported Godot version (< 3.0)")
		print("❌ Plugin requires Godot 3.x or 4.x")
		return

	print("\n=== Compatibility Check Complete ===")

func _check_godot4_compatibility():
	print("\n📋 Godot 4.x Compatibility Check:")

	# Check if @tool syntax works
	var plugin_content = _read_file("res://addons/ai_coding_assistant/plugin.gd")
	if plugin_content.begins_with("@tool"):
		print("✅ Modern @tool syntax detected")
	else:
		print("⚠️ Old 'tool' syntax found - consider updating to '@tool'")

	# Check project.godot
	var project_content = _read_file("res://project.godot")
	if "PackedStringArray" in project_content:
		print("✅ Godot 4.x project configuration detected")
	else:
		print("⚠️ Project may be configured for Godot 3.x")

	print("✅ Plugin should work without modifications!")

func _check_godot3_compatibility():
	print("\n📋 Godot 3.x Compatibility Check:")

	var issues_found = []

	# Check for @tool usage
	var plugin_content = _read_file("res://addons/ai_coding_assistant/plugin.gd")
	if plugin_content.begins_with("@tool"):
		issues_found.append("Replace '@tool' with 'tool' in all .gd files")

	# Check project.godot
	var project_content = _read_file("res://project.godot")
	if "PackedStringArray" in project_content:
		issues_found.append("Change 'PackedStringArray' to 'PoolStringArray' in project.godot")

	if issues_found.size() > 0:
		print("❌ Issues found that need fixing:")
		for issue in issues_found:
			print("   • " + issue)
		print("\n🔧 See VERSION_COMPATIBILITY.md for detailed fixes")
	else:
		print("✅ No obvious compatibility issues found!")
		print("✅ Plugin should work with Godot 3.x")

func _read_file(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""

	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return ""

	var content = file.get_as_text()
	file.close()
	return content

# Alternative version for Godot 3.x compatibility (not used in Godot 4.x)
# func _read_file_godot3(path: String) -> String:
#	var file = File.new()
#	if not file.file_exists(path):
#		return ""
#
#	if file.open(path, File.READ) != OK:
#		return ""
#
#	var content = file.get_as_text()
#	file.close()
#	return content
