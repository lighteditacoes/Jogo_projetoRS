@tool
extends EditorScript

# Test the API manager fix
# Run this from Tools > Execute Script

func _run():
	print("=== Testing API Manager Fix ===")
	
	# Test 1: Load the script
	var api_script = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	if not api_script:
		print("❌ Failed to load API script")
		return
	print("✅ API script loaded")
	
	# Test 2: Create instance
	var api_manager = api_script.new()
	if not api_manager:
		print("❌ Failed to create API manager")
		return
	print("✅ API manager created")
	
	# Test 3: Check initialization
	print("Checking initialization...")
	print("   gemini_models: ", api_manager.gemini_models)
	print("   gemini_models type: ", typeof(api_manager.gemini_models))
	if api_manager.gemini_models:
		print("   gemini_models size: ", api_manager.gemini_models.size())
		print("   First model: ", api_manager.gemini_models[0])
	
	print("   base_urls: ", api_manager.base_urls)
	print("   current_model_index: ", api_manager.current_model_index)
	print("   api_provider: ", api_manager.api_provider)
	
	# Test 4: Test model access
	if api_manager.gemini_models and api_manager.gemini_models.size() > 0:
		var current_model = api_manager.gemini_models[api_manager.current_model_index]
		print("✅ Current model: ", current_model)
		
		var test_url = api_manager.base_urls["gemini"] + current_model + ":generateContent?key=TEST"
		print("✅ Test URL: ", test_url)
	else:
		print("❌ Cannot access models")
	
	# Test 5: Test API key setting
	api_manager.set_api_key("test_key_123")
	print("✅ API key set to: ", api_manager.api_key)
	
	# Clean up
	api_manager.free()
	
	print("\n=== Fix Summary ===")
	print("✅ Removed array literal initialization")
	print("✅ Added explicit initialization in _init()")
	print("✅ Added debug output for troubleshooting")
	print("✅ Added safety checks")
	
	print("\n=== Next Steps ===")
	print("1. Restart the plugin (disable/enable)")
	print("2. Check Output tab for 'API Manager initialized with models'")
	print("3. Try sending a message")
	print("4. Look for debug output showing model array contents")
	
	print("\n=== End Test ===")
