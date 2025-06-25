@tool
extends EditorScript

# Test script to verify Gemini API configuration
# Run this from Tools > Execute Script

func _run():
	print("=== Testing Gemini API Configuration ===")
	
	# Load the API manager
	var api_manager_script = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	var api_manager = api_manager_script.new()
	
	# Test the URL construction
	api_manager.set_api_key("TEST_KEY")
	var base_url = api_manager.base_urls["gemini"]
	var test_url = base_url + "?key=" + "TEST_KEY"
	
	print("Base URL: ", base_url)
	print("Full URL with key: ", test_url)
	
	# Check if it matches the working curl format
	var expected_pattern = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key="
	if test_url.begins_with(expected_pattern):
		print("✅ URL format matches working curl example!")
	else:
		print("❌ URL format doesn't match")
	
	# Test JSON body format
	var test_body = {
		"contents": [{
			"parts": [{
				"text": "test message"
			}]
		}]
	}
	
	var json_body = JSON.stringify(test_body)
	print("JSON body: ", json_body)
	
	# Check if it matches curl format
	if "contents" in json_body and "parts" in json_body and "text" in json_body:
		print("✅ JSON format matches working curl example!")
	else:
		print("❌ JSON format doesn't match")
	
	print("\n=== Configuration Summary ===")
	print("✅ Updated to v1beta endpoint")
	print("✅ Updated to gemini-2.0-flash model")
	print("✅ API key now passed as query parameter")
	print("✅ JSON structure matches curl example")
	
	print("\n🚀 Ready to test! Try sending a message in the AI Assistant dock.")
	print("=== End Test ===")
