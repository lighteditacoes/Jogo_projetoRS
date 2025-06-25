@tool
extends EditorScript

# Simple API test to check which models work
# Run this from Tools > Execute Script

func _run():
	print("=== Simple Gemini API Test ===")

	# Test different model URLs
	var models_to_test = [
		"gemini-2.0-flash",
		"gemini-1.5-flash",
		"gemini-1.0-pro",
		"gemini-pro"
	]

	print("Models to test (in order of preference):")
	for i in range(models_to_test.size()):
		var model = models_to_test[i]
		var url = "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent"
		print(str(i + 1) + ". " + model)
		print("   URL: " + url)

	print("\n=== Current Plugin Configuration ===")

	# Load the API manager to check current settings
	var api_manager_script = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	if api_manager_script:
		var api_manager = api_manager_script.new()
		print("✅ API Manager loaded successfully")
		print("Available models: ", api_manager.gemini_models)
		print("Current model index: ", api_manager.current_model_index)
		print("Base URL: ", api_manager.base_urls["gemini"])

		# Test URL construction
		if api_manager.current_model_index < api_manager.gemini_models.size():
			var current_model = api_manager.gemini_models[api_manager.current_model_index]
			var test_url = api_manager.base_urls["gemini"] + current_model + ":generateContent?key=TEST_KEY"
			print("Test URL: ", test_url)
		else:
			print("❌ Invalid model index!")
	else:
		print("❌ Failed to load API Manager")

	print("\n=== Recommendations ===")
	print("1. Make sure you have a valid API key from: https://aistudio.google.com/app/apikey")
	print("2. The plugin will automatically try models in this order:")
	for model in models_to_test:
		print("   • " + model)
	print("3. If all models fail, check your API key and internet connection")

	print("\n=== Next Steps ===")
	print("1. Restart the plugin (disable/enable in Project Settings)")
	print("2. Add your API key to the AI Assistant dock")
	print("3. Try sending 'hello' - it should automatically find a working model")

	print("\n=== End Test ===")
