@tool
extends RefCounted

# API Configuration
var api_key: String = ""
var api_provider: String = "gemini"  # gemini, huggingface, cohere
var current_model_index: int = 0
var gemini_models: Array = []
var base_urls = {
	"gemini": "https://generativelanguage.googleapis.com/v1beta/models/",
	"huggingface": "https://api-inference.huggingface.co/models/",
	"cohere": "https://api.cohere.ai/v1/generate"
}

signal response_received(response: String)
signal error_occurred(error: String)

var http_request: HTTPRequest

func _init():
	# Always initialize arrays to ensure they're never null
	gemini_models = [
		"gemini-2.0-flash",
		"gemini-1.5-flash",
		"gemini-1.0-pro",
		"gemini-pro"
	]

	base_urls = {
		"gemini": "https://generativelanguage.googleapis.com/v1beta/models/",
		"huggingface": "https://api-inference.huggingface.co/models/",
		"cohere": "https://api.cohere.ai/v1/generate"
	}

	current_model_index = 0
	api_provider = "gemini"
	api_key = ""

	http_request = HTTPRequest.new()
	http_request.request_completed.connect(_on_request_completed)

	print("API Manager initialized with models: ", gemini_models)

func set_api_key(key: String):
	api_key = key

func set_provider(provider: String):
	if provider in base_urls:
		api_provider = provider
	else:
		push_error("Unsupported API provider: " + provider)

func send_chat_request(message: String, context: String = ""):
	if api_key.is_empty():
		error_occurred.emit("API key not set")
		return

	match api_provider:
		"gemini":
			_send_gemini_request(message, context)
		"huggingface":
			_send_huggingface_request(message, context)
		"cohere":
			_send_cohere_request(message, context)

func _send_gemini_request(message: String, context: String):
	var headers = [
		"Content-Type: application/json"
	]

	var prompt = context + "\n\n" + message if not context.is_empty() else message

	var body = {
		"contents": [{
			"parts": [{
				"text": prompt
			}]
		}]
	}

	var json_body = JSON.stringify(body)

	# Safety checks
	print("Debug: gemini_models = ", gemini_models)
	print("Debug: gemini_models type = ", typeof(gemini_models))
	if gemini_models:
		print("Debug: gemini_models size = ", gemini_models.size())

	if not gemini_models or gemini_models.size() == 0:
		print("Error: gemini_models is null or empty!")
		error_occurred.emit("No Gemini models available")
		return

	if current_model_index >= gemini_models.size():
		current_model_index = 0

	var current_model = gemini_models[current_model_index]
	var full_url = base_urls["gemini"] + current_model + ":generateContent?key=" + api_key
	print("Trying model: ", current_model)
	print("Sending request to: ", full_url)
	print("Request body: ", json_body)
	http_request.request(full_url, headers, HTTPClient.METHOD_POST, json_body)

func _send_huggingface_request(message: String, context: String):
	# Using CodeT5+ for code generation
	var model = "Salesforce/codet5p-770m-py"
	var url = base_urls["huggingface"] + model

	var headers = [
		"Authorization: Bearer " + api_key,
		"Content-Type: application/json"
	]

	var prompt = context + "\n\n" + message if not context.is_empty() else message

	var body = {
		"inputs": prompt,
		"parameters": {
			"max_length": 512,
			"temperature": 0.7,
			"do_sample": true
		}
	}

	var json_body = JSON.stringify(body)
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_body)

func _send_cohere_request(message: String, context: String):
	var headers = [
		"Authorization: Bearer " + api_key,
		"Content-Type: application/json"
	]

	var prompt = context + "\n\n" + message if not context.is_empty() else message

	var body = {
		"model": "command",
		"prompt": prompt,
		"max_tokens": 2048,
		"temperature": 0.7
	}

	var json_body = JSON.stringify(body)
	http_request.request(base_urls["cohere"], headers, HTTPClient.METHOD_POST, json_body)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("Request completed - Result: ", result, " Response code: ", response_code)
	print("Response body: ", body.get_string_from_utf8())

	if response_code != 200:
		# If 404 and we're using Gemini, try the next model
		if response_code == 404 and api_provider == "gemini" and gemini_models and current_model_index < gemini_models.size() - 1:
			current_model_index += 1
			print("Model not found, trying next model: ", gemini_models[current_model_index])
			# Retry with the last message (we'll need to store it)
			error_occurred.emit("Model not available, trying " + gemini_models[current_model_index] + "...")
			return

		var error_msg = "HTTP Error: " + str(response_code)
		if response_code == 404:
			error_msg += " - API endpoint not found. All models tried."
		elif response_code == 401:
			error_msg += " - Unauthorized. Check your API key."
		elif response_code == 403:
			error_msg += " - Forbidden. API key may not have proper permissions."
		error_occurred.emit(error_msg)
		return

	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result != OK:
		error_occurred.emit("Failed to parse JSON response")
		return

	var response_data = json.data
	var extracted_text = ""

	match api_provider:
		"gemini":
			if "candidates" in response_data and response_data["candidates"].size() > 0:
				var candidate = response_data["candidates"][0]
				if "content" in candidate and "parts" in candidate["content"]:
					extracted_text = candidate["content"]["parts"][0]["text"]
		"huggingface":
			if response_data is Array and response_data.size() > 0:
				extracted_text = response_data[0]["generated_text"]
		"cohere":
			if "generations" in response_data and response_data["generations"].size() > 0:
				extracted_text = response_data["generations"][0]["text"]

	if extracted_text.is_empty():
		error_occurred.emit("No valid response received from API")
	else:
		response_received.emit(extracted_text)

func generate_code(prompt: String, language: String = "gdscript"):
	var context = "You are a helpful coding assistant. Generate clean, well-commented " + language + " code based on the following request. Only return the code without explanations unless specifically asked:"
	send_chat_request(prompt, context)

func explain_code(code: String):
	var context = "You are a helpful coding assistant. Explain the following code in detail, including what it does, how it works, and any potential improvements:"
	send_chat_request(code, context)

func suggest_improvements(code: String):
	var context = "You are a helpful coding assistant. Analyze the following code and suggest improvements for performance, readability, and best practices:"
	send_chat_request(code, context)
