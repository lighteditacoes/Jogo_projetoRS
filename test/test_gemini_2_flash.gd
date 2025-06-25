@tool
extends EditorScript

# Test script specifically for gemini-2.0-flash model
# Run this from Tools > Execute Script

func _run():
	print("=== Testing Gemini 2.0 Flash Model ===")
	
	# Test the exact URL format that should work
	var model = "gemini-2.0-flash"
	var base_url = "https://generativelanguage.googleapis.com/v1beta/models/"
	var full_url = base_url + model + ":generateContent?key=YOUR_API_KEY"
	
	print("Model: ", model)
	print("Full URL: ", full_url)
	
	# Test JSON body format
	var test_body = {
		"contents": [{
			"parts": [{
				"text": "Hello, can you help me with coding?"
			}]
		}]
	}
	
	var json_body = JSON.stringify(test_body)
	print("JSON Body: ", json_body)
	
	print("\n=== Model Information ===")
	print("✨ Gemini 2.0 Flash is Google's latest and most advanced free model")
	print("🚀 Features:")
	print("   • Faster response times")
	print("   • Better code understanding")
	print("   • Improved reasoning capabilities")
	print("   • Enhanced multimodal support")
	print("   • Free tier available")
	
	print("\n=== Updated Model Priority ===")
	print("The plugin will now try models in this order:")
	print("1. 🥇 gemini-2.0-flash (newest, fastest)")
	print("2. 🥈 gemini-1.5-flash (reliable backup)")
	print("3. 🥉 gemini-1.0-pro (stable fallback)")
	print("4. 🔄 gemini-pro (legacy fallback)")
	
	print("\n=== Expected Benefits ===")
	print("✅ Faster AI responses")
	print("✅ Better code generation quality")
	print("✅ More accurate explanations")
	print("✅ Improved GDScript understanding")
	print("✅ Better debugging suggestions")
	
	print("\n=== Ready to Test! ===")
	print("1. Restart the plugin (disable/enable)")
	print("2. Add your API key from: https://aistudio.google.com/app/apikey")
	print("3. Type 'hello' to test the new model")
	print("4. Should see: 'Trying model: gemini-2.0-flash'")
	
	print("\n=== End Test ===")
