@tool
extends EditorScript

# Debug script to test API manager initialization
# Run this from Tools > Execute Script

func _run():
	print("=== Debug API Manager ===")
	
	# Test loading the API manager
	var api_manager_script = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	if not api_manager_script:
		print("❌ Failed to load API manager script")
		return
	
	print("✅ API manager script loaded")
	
	# Test creating an instance
	var api_manager = api_manager_script.new()
	if not api_manager:
		print("❌ Failed to create API manager instance")
		return
	
	print("✅ API manager instance created")
	
	# Test the arrays
	print("Checking gemini_models array...")
	if api_manager.gemini_models:
		print("✅ gemini_models exists")
		print("   Type: ", typeof(api_manager.gemini_models))
		print("   Size: ", api_manager.gemini_models.size())
		print("   Contents: ", api_manager.gemini_models)
	else:
		print("❌ gemini_models is null")
	
	print("Checking base_urls dictionary...")
	if api_manager.base_urls:
		print("✅ base_urls exists")
		print("   Type: ", typeof(api_manager.base_urls))
		print("   Contents: ", api_manager.base_urls)
	else:
		print("❌ base_urls is null")
	
	print("Checking other properties...")
	print("   current_model_index: ", api_manager.current_model_index)
	print("   api_provider: ", api_manager.api_provider)
	print("   api_key: ", api_manager.api_key)
	
	# Test setting API key
	api_manager.set_api_key("test_key")
	print("   api_key after setting: ", api_manager.api_key)
	
	# Test URL construction
	if api_manager.gemini_models and api_manager.gemini_models.size() > 0:
		var current_model = api_manager.gemini_models[0]
		var test_url = api_manager.base_urls["gemini"] + current_model + ":generateContent?key=TEST"
		print("✅ Test URL construction: ", test_url)
	else:
		print("❌ Cannot test URL construction - no models available")
	
	# Clean up
	api_manager.free()
	
	print("\n=== Debug Complete ===")
	print("If all checks passed, the API manager should work correctly.")
	print("If any failed, there's an initialization issue.")
