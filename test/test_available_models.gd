@tool
extends EditorScript

# Test script to check available Gemini models
# Run this from Tools > Execute Script

var http_request: HTTPRequest
var api_key: String = ""

func _run():
	print("=== Testing Available Gemini Models ===")

	# You need to set your API key here for testing
	api_key = "YOUR_API_KEY_HERE"  # Replace with your actual API key

	if api_key == "YOUR_API_KEY_HERE":
		print("❌ Please set your API key in the script first!")
		print("Edit test_available_models.gd and replace YOUR_API_KEY_HERE with your actual key")
		return

	# Create HTTP request
	http_request = HTTPRequest.new()
	# Note: EditorScript doesn't support add_child, so we'll create a simple test
	print("Note: This is a simplified test - full HTTP testing requires a scene context")

	# Test different model endpoints
	var models_to_test = [
		"gemini-1.5-flash",
		"gemini-1.5-pro",
		"gemini-pro",
		"gemini-1.0-pro"
	]

	print("Testing models: ", models_to_test)
	print("First, let's list available models...")

	# List available models
	var list_url = "https://generativelanguage.googleapis.com/v1beta/models?key=" + api_key
	var headers = ["Content-Type: application/json"]

	print("Requesting: ", list_url)
	http_request.request(list_url, headers, HTTPClient.METHOD_GET)

func _on_list_models_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("\n=== Available Models Response ===")
	print("Response code: ", response_code)

	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		print("Available models:")
		print(response_text)

		# Parse and show model names
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		if parse_result == OK:
			var data = json.data
			if "models" in data:
				print("\n📋 Model List:")
				for model in data["models"]:
					if "name" in model:
						var model_name = model["name"]
						var supports_generate = false
						if "supportedGenerationMethods" in model:
							supports_generate = "generateContent" in model["supportedGenerationMethods"]

						print("  • ", model_name, " - generateContent: ", supports_generate)

						# Check if it's a free model
						if supports_generate and ("flash" in model_name.to_lower() or "pro" in model_name.to_lower()):
							print("    ✅ This model supports generateContent!")
	else:
		print("❌ Failed to get models list")
		print("Response: ", body.get_string_from_utf8())

	print("\n=== Recommended Free Models ===")
	print("Try these models (usually free):")
	print("• gemini-1.5-flash (fastest, free)")
	print("• gemini-1.0-pro (stable, free)")
	print("• gemini-pro (legacy, free)")

	# Clean up
	http_request.queue_free()
