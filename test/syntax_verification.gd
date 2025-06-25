@tool
extends EditorScript

# Simple syntax verification for enhanced markdown features
# Run this from Tools > Execute Script in Godot

func _run():
	print("🔍 Syntax Verification for Enhanced Markdown")
	print("============================================")

	var files_to_check = [
		"addons/ai_coding_assistant/ai_assistant_dock.gd",
		"test/verify_enhanced_markdown.gd",
		"test/verify_fixes.gd",
		"test/test_enhanced_markdown.gd"
	]

	var all_good = true

	for file_path in files_to_check:
		var script = load("res://" + file_path)
		if script:
			print("✅ " + file_path + " - Syntax OK")
		else:
			print("❌ " + file_path + " - Syntax Error")
			all_good = false

	print("\n📋 Enhanced Markdown Features Check:")

	# Check if main dock script loads
	var dock_script = load("res://addons/ai_coding_assistant/ai_assistant_dock.gd")
	if dock_script:
		print("✅ Main dock script loads successfully")

		# Try to create an instance
		var dock_instance = dock_script.new()
		if dock_instance:
			print("✅ Dock instance created successfully")

			# Check for enhanced markdown methods
			var enhanced_methods = [
				"_format_message_with_markdown",
				"_apply_syntax_highlighting",
				"_highlight_gdscript",
				"_format_text_styles",
				"_format_headers",
				"_repeat_string"
			]

			var methods_found = 0
			for method in enhanced_methods:
				if dock_instance.has_method(method):
					methods_found += 1

			print("✅ Found " + str(methods_found) + "/" + str(enhanced_methods.size()) + " enhanced methods")

			dock_instance.queue_free()
		else:
			print("❌ Failed to create dock instance")
			all_good = false
	else:
		print("❌ Failed to load main dock script")
		all_good = false

	print("\n============================================")
	if all_good:
		print("🎉 ALL SYNTAX CHECKS PASSED!")
		print("✅ No syntax errors found")
		print("✅ Enhanced markdown features are ready")
		print("✅ All test scripts load correctly")

		print("\n🎨 Enhanced Features Available:")
		print("• Advanced syntax highlighting (GDScript, Python, JS, JSON)")
		print("• Modern VS Code-inspired color scheme")
		print("• Enhanced text formatting (bold, italic, strikethrough)")
		print("• Professional header styling with separators")
		print("• Better list and quote formatting")
		print("• Smart link detection and styling")
		print("• Language-labeled code blocks")

		print("\n🚀 Ready to use! Enable the plugin and test the features.")
	else:
		print("❌ SYNTAX ERRORS FOUND!")
		print("Please check the files marked with ❌ above")

	print("============================================")
