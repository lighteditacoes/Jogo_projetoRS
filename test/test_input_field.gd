@tool
extends EditorScript

# Test script to debug input field issues
# Run this from Tools > Execute Script

func _run():
	print("=== Testing Input Field ===")
	
	# Try to find the AI Assistant dock
	var editor_main = EditorInterface.get_editor_main_screen()
	print("Editor main screen: ", editor_main)
	
	# Check if we can access the dock
	var docks = []
	_find_ai_dock(editor_main, docks)
	
	if docks.size() > 0:
		print("Found AI Assistant dock!")
		var dock = docks[0]
		
		# Try to find the input field
		var input_field = _find_input_field(dock)
		if input_field:
			print("Found input field: ", input_field)
			print("Input field editable: ", input_field.editable)
			print("Input field placeholder: ", input_field.placeholder_text)
			
			# Try to set focus
			input_field.grab_focus()
			print("Attempted to grab focus")
			
			# Try to set some text
			input_field.text = "Test message"
			print("Set test text: ", input_field.text)
		else:
			print("Could not find input field")
	else:
		print("Could not find AI Assistant dock")
	
	print("=== Test Complete ===")

func _find_ai_dock(node: Node, found_docks: Array):
	if node.name == "AI Assistant":
		found_docks.append(node)
		return
	
	for child in node.get_children():
		_find_ai_dock(child, found_docks)

func _find_input_field(node: Node):
	if node is LineEdit and "Ask me anything" in node.placeholder_text:
		return node
	
	for child in node.get_children():
		var result = _find_input_field(child)
		if result:
			return result
	
	return null
