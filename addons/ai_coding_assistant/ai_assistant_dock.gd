@tool
extends Control

var api_manager
var chat_history: RichTextLabel
var input_field: LineEdit
var send_button: Button
var provider_option: OptionButton
var api_key_field: LineEdit
var code_output: TextEdit
var apply_button: Button
var explain_button: Button
var improve_button: Button

# UI containers for better resizing
var main_splitter: VSplitContainer
var settings_container: VBoxContainer
var chat_container: VBoxContainer
var code_container: VBoxContainer
var quick_actions_container: VBoxContainer

# Context menus and enhanced features
var chat_context_menu: PopupMenu
var code_context_menu: PopupMenu
var chat_clear_button: Button
var code_copy_button: Button
var code_save_button: Button

# Enhanced view options
var chat_word_wrap_button: Button
var code_line_numbers_button: Button
var chat_word_wrap_enabled: bool = true
var code_line_numbers_enabled: bool = false

# Collapsible sections
var settings_collapsed: bool = false
var quick_actions_collapsed: bool = false

var current_generated_code: String = ""
var settings_dialog: Window
var setup_guide: Window

func _init():
	name = "AI Assistant"
	# Enhanced flexible sizing for better screen adaptation
	set_custom_minimum_size(Vector2(200, 250))  # Reduced minimum for smaller screens
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Enable automatic resizing and anchoring
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Connect to viewport size changes for responsive design (deferred)
	call_deferred("_connect_viewport_signals")

	var AIApiManager = load("res://addons/ai_coding_assistant/ai_api_manager.gd")
	api_manager = AIApiManager.new()
	add_child(api_manager.http_request)
	api_manager.response_received.connect(_on_response_received)
	api_manager.error_occurred.connect(_on_error_occurred)

	_setup_ui()
	_load_settings()
	_setup_keyboard_shortcuts()

func _setup_ui():
	# Create main container with enhanced flexible sizing
	var main_container = VBoxContainer.new()
	main_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(main_container)

	# Create settings section (collapsible)
	_create_settings_section(main_container)

	# Add separator with flexible spacing
	var separator1 = HSeparator.new()
	separator1.add_theme_constant_override("separation", 2)
	main_container.add_child(separator1)

	# Create main splitter for chat and code sections with enhanced flexibility
	main_splitter = VSplitContainer.new()
	main_splitter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_splitter.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_splitter.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Dynamic split position based on screen size (deferred)
	main_splitter.split_offset = 200  # Default value, will be updated by responsive design
	main_container.add_child(main_splitter)

	# Create chat section
	_create_chat_section(main_splitter)

	# Create code section
	_create_code_section(main_splitter)

	# Add separator with flexible spacing
	var separator2 = HSeparator.new()
	separator2.add_theme_constant_override("separation", 2)
	main_container.add_child(separator2)

	# Create quick actions section (collapsible)
	_create_quick_actions_section(main_container)

	# Apply responsive design after UI is created
	call_deferred("_apply_responsive_design")

func _create_settings_section(parent: Container):
	settings_container = VBoxContainer.new()

	# Settings header with collapse button
	var settings_header = HBoxContainer.new()
	var collapse_button = Button.new()
	collapse_button.text = "▼" if not settings_collapsed else "▶"
	collapse_button.set_custom_minimum_size(Vector2(20, 20))
	collapse_button.pressed.connect(_toggle_settings_collapse)

	var settings_label = Label.new()
	settings_label.text = "API Settings"
	settings_label.add_theme_font_size_override("font_size", 14)
	settings_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var help_button = Button.new()
	help_button.text = "?"
	help_button.set_custom_minimum_size(Vector2(25, 25))
	help_button.pressed.connect(_on_help_pressed)

	var settings_button = Button.new()
	settings_button.text = "⚙"
	settings_button.set_custom_minimum_size(Vector2(25, 25))
	settings_button.pressed.connect(_on_settings_pressed)

	settings_header.add_child(collapse_button)
	settings_header.add_child(settings_label)
	settings_header.add_child(help_button)
	settings_header.add_child(settings_button)
	settings_container.add_child(settings_header)

	# Settings content (collapsible)
	var settings_content = VBoxContainer.new()
	settings_content.visible = not settings_collapsed

	# Provider selection with better layout
	var provider_hbox = HBoxContainer.new()
	var provider_label = Label.new()
	provider_label.text = "Provider:"
	provider_label.set_custom_minimum_size(Vector2(60, 0))
	provider_option = OptionButton.new()
	provider_option.add_item("Gemini (Free)")
	provider_option.add_item("Hugging Face")
	provider_option.add_item("Cohere")
	provider_option.selected = 0
	provider_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	provider_option.item_selected.connect(_on_provider_changed)
	provider_hbox.add_child(provider_label)
	provider_hbox.add_child(provider_option)
	settings_content.add_child(provider_hbox)

	# API Key input with better layout
	var key_hbox = HBoxContainer.new()
	var key_label = Label.new()
	key_label.text = "API Key:"
	key_label.set_custom_minimum_size(Vector2(60, 0))
	api_key_field = LineEdit.new()
	api_key_field.placeholder_text = "Enter your API key"
	api_key_field.secret = true
	api_key_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	api_key_field.text_changed.connect(_on_api_key_changed)
	key_hbox.add_child(key_label)
	key_hbox.add_child(api_key_field)
	settings_content.add_child(key_hbox)

	settings_container.add_child(settings_content)
	parent.add_child(settings_container)

func _create_chat_section(parent: Container):
	chat_container = VBoxContainer.new()
	chat_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Chat header with action buttons
	var chat_header = HBoxContainer.new()
	var chat_label = Label.new()
	chat_label.text = "AI Chat"
	chat_label.add_theme_font_size_override("font_size", 14)
	chat_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Word wrap toggle button
	chat_word_wrap_button = Button.new()
	chat_word_wrap_button.text = "↩" if chat_word_wrap_enabled else "→"
	chat_word_wrap_button.tooltip_text = "Toggle word wrap"
	chat_word_wrap_button.set_custom_minimum_size(Vector2(25, 25))
	chat_word_wrap_button.pressed.connect(_on_toggle_chat_word_wrap)

	# Clear chat button
	chat_clear_button = Button.new()
	chat_clear_button.text = "🗑"
	chat_clear_button.tooltip_text = "Clear chat history"
	chat_clear_button.set_custom_minimum_size(Vector2(25, 25))
	chat_clear_button.pressed.connect(_on_clear_chat)

	chat_header.add_child(chat_label)
	chat_header.add_child(chat_word_wrap_button)
	chat_header.add_child(chat_clear_button)
	chat_container.add_child(chat_header)

	# Create scrollable container for chat history
	var chat_scroll = ScrollContainer.new()
	chat_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	chat_scroll.set_custom_minimum_size(Vector2(0, 150))  # Default minimum height

	# Enable scrolling
	chat_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	chat_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	chat_scroll.follow_focus = true

	# Chat history with enhanced markdown support and flexible sizing
	chat_history = RichTextLabel.new()
	chat_history.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_history.size_flags_vertical = Control.SIZE_EXPAND_FILL
	chat_history.bbcode_enabled = true
	chat_history.scroll_following = true
	chat_history.selection_enabled = true  # Enable text selection
	chat_history.context_menu_enabled = true  # Enable built-in context menu

	# Enhanced text properties for better readability
	chat_history.fit_content = true
	chat_history.scroll_active = true
	chat_history.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Better font and styling
	_setup_chat_styling()

	# Create context menu for chat
	_create_chat_context_menu()
	chat_history.gui_input.connect(_on_chat_gui_input)

	# Add chat history to scroll container
	chat_scroll.add_child(chat_history)
	chat_container.add_child(chat_scroll)

	# Sticky footer: Input section with better layout
	var input_footer = VBoxContainer.new()
	input_footer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_footer.size_flags_vertical = Control.SIZE_SHRINK_END  # Stick to bottom

	# Add a subtle separator above input
	var input_separator = HSeparator.new()
	input_separator.add_theme_constant_override("separation", 1)
	input_footer.add_child(input_separator)

	var input_hbox = HBoxContainer.new()
	input_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	input_field = LineEdit.new()
	input_field.placeholder_text = "Ask me anything about coding..."
	input_field.editable = true
	input_field.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_field.text_submitted.connect(_on_send_message)

	send_button = Button.new()
	send_button.text = "Send"
	send_button.set_custom_minimum_size(Vector2(60, 0))
	send_button.pressed.connect(_on_send_pressed)

	input_hbox.add_child(input_field)
	input_hbox.add_child(send_button)
	input_footer.add_child(input_hbox)

	chat_container.add_child(input_footer)

	parent.add_child(chat_container)

func _create_code_section(parent: Container):
	code_container = VBoxContainer.new()
	code_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Code header with action buttons
	var code_header = HBoxContainer.new()
	var code_label = Label.new()
	code_label.text = "Generated Code"
	code_label.add_theme_font_size_override("font_size", 14)
	code_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Line numbers toggle button
	code_line_numbers_button = Button.new()
	code_line_numbers_button.text = "#" if code_line_numbers_enabled else "∅"
	code_line_numbers_button.tooltip_text = "Toggle line numbers"
	code_line_numbers_button.set_custom_minimum_size(Vector2(25, 25))
	code_line_numbers_button.pressed.connect(_on_toggle_code_line_numbers)

	# Copy code button
	code_copy_button = Button.new()
	code_copy_button.text = "📋"
	code_copy_button.tooltip_text = "Copy code to clipboard"
	code_copy_button.set_custom_minimum_size(Vector2(25, 25))
	code_copy_button.pressed.connect(_on_copy_code)

	# Save code button
	code_save_button = Button.new()
	code_save_button.text = "💾"
	code_save_button.tooltip_text = "Save code to file"
	code_save_button.set_custom_minimum_size(Vector2(25, 25))
	code_save_button.pressed.connect(_on_save_code)

	code_header.add_child(code_label)
	code_header.add_child(code_line_numbers_button)
	code_header.add_child(code_copy_button)
	code_header.add_child(code_save_button)
	code_container.add_child(code_header)

	# Create scrollable container for code output
	var code_scroll = ScrollContainer.new()
	code_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	code_scroll.set_custom_minimum_size(Vector2(0, 120))  # Default minimum height

	# Enable scrolling for code
	code_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	code_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	code_scroll.follow_focus = true

	# Enhanced code output with flexible sizing and better editing capabilities
	code_output = TextEdit.new()
	code_output.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_output.size_flags_vertical = Control.SIZE_EXPAND_FILL
	code_output.placeholder_text = "Generated code will appear here...\nThis area is fully editable - you can modify code before applying it."
	code_output.editable = true  # Allow editing

	# Enhanced code editing features
	code_output.wrap_mode = TextEdit.LINE_WRAPPING_NONE  # No wrapping for code
	code_output.scroll_horizontal = true  # Correct property name for Godot 4.x
	code_output.scroll_vertical_enabled = true
	code_output.context_menu_enabled = true  # Enable built-in context menu
	code_output.selecting_enabled = true
	code_output.deselect_on_focus_loss_enabled = false
	code_output.drag_and_drop_selection_enabled = true
	code_output.virtual_keyboard_enabled = false  # Better for code editing

	# Better code styling
	_setup_code_styling()

	# Create context menu for code
	_create_code_context_menu()
	code_output.gui_input.connect(_on_code_gui_input)

	# Add code output to scroll container
	code_scroll.add_child(code_output)
	code_container.add_child(code_scroll)

	# Action buttons with better layout
	var button_hbox = HBoxContainer.new()
	button_hbox.alignment = BoxContainer.ALIGNMENT_CENTER

	apply_button = Button.new()
	apply_button.text = "Apply to Script"
	apply_button.pressed.connect(_on_apply_code)
	apply_button.disabled = true
	apply_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	explain_button = Button.new()
	explain_button.text = "Explain"
	explain_button.pressed.connect(_on_explain_code)
	explain_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	improve_button = Button.new()
	improve_button.text = "Improve"
	improve_button.pressed.connect(_on_improve_code)
	improve_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	button_hbox.add_child(apply_button)
	button_hbox.add_child(explain_button)
	button_hbox.add_child(improve_button)
	code_container.add_child(button_hbox)

	parent.add_child(code_container)

func _create_quick_actions_section(parent: Container):
	quick_actions_container = VBoxContainer.new()

	# Quick actions header with collapse button
	var quick_header = HBoxContainer.new()
	var collapse_button = Button.new()
	collapse_button.text = "▼" if not quick_actions_collapsed else "▶"
	collapse_button.set_custom_minimum_size(Vector2(20, 20))
	collapse_button.pressed.connect(_toggle_quick_actions_collapse)

	var quick_label = Label.new()
	quick_label.text = "Quick Actions"
	quick_label.add_theme_font_size_override("font_size", 14)
	quick_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	quick_header.add_child(collapse_button)
	quick_header.add_child(quick_label)
	quick_actions_container.add_child(quick_header)

	# Quick actions content (collapsible)
	var quick_content = VBoxContainer.new()
	quick_content.visible = not quick_actions_collapsed

	var gen_class_btn = Button.new()
	gen_class_btn.text = "Generate Class Template"
	gen_class_btn.pressed.connect(_on_generate_class)
	gen_class_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var gen_singleton_btn = Button.new()
	gen_singleton_btn.text = "Generate Singleton"
	gen_singleton_btn.pressed.connect(_on_generate_singleton)
	gen_singleton_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var gen_ui_btn = Button.new()
	gen_ui_btn.text = "Generate UI Controller"
	gen_ui_btn.pressed.connect(_on_generate_ui)
	gen_ui_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	quick_content.add_child(gen_class_btn)
	quick_content.add_child(gen_singleton_btn)
	quick_content.add_child(gen_ui_btn)

	quick_actions_container.add_child(quick_content)
	parent.add_child(quick_actions_container)

# Styling setup functions
func _setup_chat_styling():
	# Enhanced chat styling for better readability and markdown support
	if chat_history:
		# Set better margins for text
		chat_history.add_theme_constant_override("margin_left", 12)
		chat_history.add_theme_constant_override("margin_right", 12)
		chat_history.add_theme_constant_override("margin_top", 8)
		chat_history.add_theme_constant_override("margin_bottom", 8)

		# Better line spacing for enhanced readability
		chat_history.add_theme_constant_override("line_separation", 4)

		# Enhanced table styling for code blocks
		chat_history.add_theme_constant_override("table_h_separation", 0)
		chat_history.add_theme_constant_override("table_v_separation", 2)

		# Better text rendering
		chat_history.add_theme_constant_override("outline_size", 0)

		# Enable advanced text features
		chat_history.threaded = true
		chat_history.meta_underlined = false

# Helper function for connecting viewport signals
func _connect_viewport_signals():
	if get_viewport():
		get_viewport().size_changed.connect(_on_viewport_size_changed)

# Responsive design functions
func _calculate_initial_split_position():
	# Calculate initial split position based on screen size
	if not main_splitter:
		return

	var viewport_size = get_viewport().get_visible_rect().size if get_viewport() else Vector2(800, 600)
	var dock_height = viewport_size.y * 0.8  # Assume dock takes 80% of screen height

	# Set split position to give more space to chat on larger screens
	if dock_height > 600:
		main_splitter.split_offset = int(dock_height * 0.4)  # 40% for chat
	elif dock_height > 400:
		main_splitter.split_offset = int(dock_height * 0.35)  # 35% for chat
	else:
		main_splitter.split_offset = int(dock_height * 0.3)  # 30% for chat on small screens

func _calculate_dynamic_min_height(section: String) -> int:
	# Calculate dynamic minimum heights based on screen size
	var viewport_size = get_viewport().get_visible_rect().size if get_viewport() else Vector2(800, 600)
	var screen_height = viewport_size.y

	match section:
		"chat":
			if screen_height > 1000:
				return 200  # Large screens
			elif screen_height > 600:
				return 150  # Medium screens
			else:
				return 100  # Small screens
		"code":
			if screen_height > 1000:
				return 180  # Large screens
			elif screen_height > 600:
				return 120  # Medium screens
			else:
				return 80   # Small screens
		_:
			return 100

func _on_viewport_size_changed():
	# Handle viewport size changes for responsive design
	call_deferred("_apply_responsive_design")

func _apply_responsive_design():
	# Apply responsive design based on current screen size
	if not is_inside_tree():
		return

	var viewport_size = get_viewport().get_visible_rect().size if get_viewport() else Vector2(800, 600)
	var screen_width = viewport_size.x
	var screen_height = viewport_size.y

	# Adjust minimum sizes based on screen size
	if chat_container:
		var min_chat_height = _calculate_dynamic_min_height("chat")
		# Find the scroll container and set its minimum size
		for child in chat_container.get_children():
			if child is ScrollContainer:
				child.set_custom_minimum_size(Vector2(0, min_chat_height))
				break

	if code_container:
		var min_code_height = _calculate_dynamic_min_height("code")
		# Find the scroll container and set its minimum size
		for child in code_container.get_children():
			if child is ScrollContainer:
				child.set_custom_minimum_size(Vector2(0, min_code_height))
				break

	# Adjust dock minimum size based on screen
	if screen_width < 400:
		set_custom_minimum_size(Vector2(180, 200))  # Very small screens
	elif screen_width < 800:
		set_custom_minimum_size(Vector2(200, 250))  # Small screens
	else:
		set_custom_minimum_size(Vector2(250, 300))  # Normal screens

	# Auto-collapse sections on very small screens
	if screen_height < 500:
		if not settings_collapsed:
			_toggle_settings_collapse()
		if not quick_actions_collapsed:
			_toggle_quick_actions_collapse()

	# Recalculate split position if needed
	if main_splitter and main_splitter.split_offset == 200:  # Only if still at default
		_calculate_initial_split_position()

func _setup_code_styling():
	# Enhanced code styling for better editing
	if code_output:
		# Set monospace font for code
		var code_font = ThemeDB.fallback_font
		if code_font:
			code_output.add_theme_font_override("font", code_font)

		# Better margins and spacing
		code_output.add_theme_constant_override("line_spacing", 2)

		# Set tab size for better code formatting
		code_output.set_tab_size(4)

		# Enable some helpful features
		code_output.caret_blink = true
		code_output.caret_multiple = true

# Context menu creation functions
func _create_chat_context_menu():
	chat_context_menu = PopupMenu.new()
	chat_context_menu.add_item("Copy Selected Text", 0)
	chat_context_menu.add_item("Copy All Chat", 1)
	chat_context_menu.add_separator()
	chat_context_menu.add_item("Save Chat History", 2)
	chat_context_menu.add_item("Clear Chat", 3)
	chat_context_menu.id_pressed.connect(_on_chat_context_menu_pressed)
	add_child(chat_context_menu)

func _create_code_context_menu():
	code_context_menu = PopupMenu.new()
	code_context_menu.add_item("Copy", 0)
	code_context_menu.add_item("Cut", 1)
	code_context_menu.add_item("Paste", 2)
	code_context_menu.add_separator()
	code_context_menu.add_item("Select All", 3)
	code_context_menu.add_separator()
	code_context_menu.add_item("Save to File", 4)
	code_context_menu.add_item("Clear Code", 5)
	code_context_menu.id_pressed.connect(_on_code_context_menu_pressed)
	add_child(code_context_menu)

# GUI input handlers for context menus
func _on_chat_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			chat_context_menu.position = get_global_mouse_position()
			chat_context_menu.popup()

func _on_code_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed:
			code_context_menu.position = get_global_mouse_position()
			code_context_menu.popup()

# Collapse toggle functions
func _toggle_settings_collapse():
	settings_collapsed = not settings_collapsed
	_refresh_settings_section()

func _toggle_quick_actions_collapse():
	quick_actions_collapsed = not quick_actions_collapsed
	_refresh_quick_actions_section()

func _refresh_settings_section():
	if settings_container:
		var header = settings_container.get_child(0) as HBoxContainer
		var collapse_button = header.get_child(0) as Button
		collapse_button.text = "▼" if not settings_collapsed else "▶"

		var content = settings_container.get_child(1)
		content.visible = not settings_collapsed

func _refresh_quick_actions_section():
	if quick_actions_container:
		var header = quick_actions_container.get_child(0) as HBoxContainer
		var collapse_button = header.get_child(0) as Button
		collapse_button.text = "▼" if not quick_actions_collapsed else "▶"

		var content = quick_actions_container.get_child(1)
		content.visible = not quick_actions_collapsed

# Context menu action handlers
func _on_chat_context_menu_pressed(id: int):
	match id:
		0: # Copy Selected Text
			var selected_text = chat_history.get_selected_text()
			if not selected_text.is_empty():
				DisplayServer.clipboard_set(selected_text)
				_add_to_chat("System", "Selected text copied to clipboard", Color.YELLOW)
		1: # Copy All Chat
			var all_text = chat_history.get_parsed_text()
			DisplayServer.clipboard_set(all_text)
			_add_to_chat("System", "All chat history copied to clipboard", Color.YELLOW)
		2: # Save Chat History
			_save_chat_history()
		3: # Clear Chat
			_on_clear_chat()

func _on_code_context_menu_pressed(id: int):
	match id:
		0: # Copy
			var selected_text = code_output.get_selected_text()
			if selected_text.is_empty():
				selected_text = code_output.text
			DisplayServer.clipboard_set(selected_text)
		1: # Cut
			var selected_text = code_output.get_selected_text()
			if not selected_text.is_empty():
				DisplayServer.clipboard_set(selected_text)
				code_output.delete_selection()
		2: # Paste
			var clipboard_text = DisplayServer.clipboard_get()
			code_output.insert_text_at_caret(clipboard_text)
		3: # Select All
			code_output.select_all()
		4: # Save to File
			_on_save_code()
		5: # Clear Code
			code_output.clear()
			current_generated_code = ""
			apply_button.disabled = true

# New action button handlers
func _on_clear_chat():
	chat_history.clear()
	_add_to_chat("System", "Chat history cleared", Color.YELLOW)

func _on_copy_code():
	if not code_output.text.is_empty():
		DisplayServer.clipboard_set(code_output.text)
		_add_to_chat("System", "Code copied to clipboard", Color.YELLOW)

func _on_save_code():
	if code_output.text.is_empty():
		_add_to_chat("System", "No code to save", Color.YELLOW)
		return

	# Create a simple file dialog
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.add_filter("*.gd", "GDScript Files")
	file_dialog.add_filter("*.txt", "Text Files")
	file_dialog.current_file = "generated_code.gd"
	file_dialog.file_selected.connect(_on_code_file_selected)
	get_viewport().add_child(file_dialog)
	file_dialog.popup_centered(Vector2i(800, 600))

func _on_code_file_selected(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(code_output.text)
		file.close()
		_add_to_chat("System", "Code saved to: " + path, Color.YELLOW)
	else:
		_add_to_chat("Error", "Failed to save code to file", Color.RED)

func _save_chat_history():
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.add_filter("*.txt", "Text Files")
	file_dialog.add_filter("*.md", "Markdown Files")
	file_dialog.current_file = "chat_history.txt"
	file_dialog.file_selected.connect(_on_chat_file_selected)
	get_viewport().add_child(file_dialog)
	file_dialog.popup_centered(Vector2i(800, 600))

func _on_chat_file_selected(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var chat_text = chat_history.get_parsed_text()
		file.store_string(chat_text)
		file.close()
		_add_to_chat("System", "Chat history saved to: " + path, Color.YELLOW)
	else:
		_add_to_chat("Error", "Failed to save chat history", Color.RED)

# View toggle functions
func _on_toggle_chat_word_wrap():
	chat_word_wrap_enabled = not chat_word_wrap_enabled
	if chat_history:
		chat_history.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if chat_word_wrap_enabled else TextServer.AUTOWRAP_OFF

	# Update button appearance
	if chat_word_wrap_button:
		chat_word_wrap_button.text = "↩" if chat_word_wrap_enabled else "→"
		chat_word_wrap_button.tooltip_text = "Word wrap: " + ("ON" if chat_word_wrap_enabled else "OFF")

func _on_toggle_code_line_numbers():
	code_line_numbers_enabled = not code_line_numbers_enabled
	if code_output:
		code_output.gutters_draw_line_numbers = code_line_numbers_enabled  # Correct property name for Godot 4.x

	# Update button appearance
	if code_line_numbers_button:
		code_line_numbers_button.text = "#" if code_line_numbers_enabled else "∅"
		code_line_numbers_button.tooltip_text = "Line numbers: " + ("ON" if code_line_numbers_enabled else "OFF")

func _on_provider_changed(index: int):
	var providers = ["gemini", "huggingface", "cohere"]
	api_manager.set_provider(providers[index])

func _on_api_key_changed(new_text: String):
	api_manager.set_api_key(new_text)

func _on_send_pressed():
	_on_send_message(input_field.text)

func _on_send_message(message: String):
	if message.is_empty():
		return

	_add_to_chat("You", message, Color.CYAN)
	input_field.clear()
	send_button.disabled = true

	# Check if this is a code generation request
	if "generate" in message.to_lower() or "create" in message.to_lower() or "write" in message.to_lower():
		api_manager.generate_code(message)
	else:
		api_manager.send_chat_request(message)

func _quick_generate(prompt: String):
	_add_to_chat("System", "Generating: " + prompt, Color.YELLOW)
	send_button.disabled = true
	api_manager.generate_code(prompt)

func _on_generate_class():
	_add_to_chat("System", "Testing Quick Action: Generate Class Template", Color.YELLOW)
	_quick_generate("Create a basic GDScript class template with common methods")

func _on_generate_singleton():
	_add_to_chat("System", "Testing Quick Action: Generate Singleton", Color.YELLOW)
	_quick_generate("Create a GDScript singleton/autoload script template")

func _on_generate_ui():
	_add_to_chat("System", "Testing Quick Action: Generate UI Controller", Color.YELLOW)
	_quick_generate("Create a GDScript UI controller with common UI interaction methods")

func _on_response_received(response: String):
	send_button.disabled = false
	_add_to_chat("AI", response, Color.GREEN)

	# If response looks like code, put it in the code output
	if _is_code_response(response):
		current_generated_code = _extract_code(response)
		code_output.text = current_generated_code
		apply_button.disabled = false

func _on_error_occurred(error: String):
	send_button.disabled = false
	_add_to_chat("Error", error, Color.RED)

func _add_to_chat(sender: String, message: String, color: Color):
	var color_hex = "#" + color.to_html(false)
	var formatted_message = _format_message_with_markdown(message)

	# Enhanced formatting with better visual separation
	var datetime_parts = Time.get_datetime_string_from_system().split(" ")
	var timestamp = ""
	if datetime_parts.size() >= 2:
		timestamp = datetime_parts[1].substr(0, 5)  # HH:MM format
	else:
		timestamp = Time.get_time_string_from_system().substr(0, 5)  # Fallback to time only
	var sender_text = "[color=" + color_hex + "][b]" + sender + "[/b][/color] [color=#888888][" + timestamp + "][/color]"

	chat_history.append_text(sender_text + "\n" + formatted_message + "\n\n")

func _format_message_with_markdown(message: String) -> String:
	# Enhanced markdown formatting with error handling
	var formatted = message

	# Safety check for empty or null messages
	if formatted.is_empty():
		return formatted

	# Format code blocks with language-specific syntax highlighting
	var regex_code_block = RegEx.new()
	if regex_code_block.compile("```(\\w+)?\\n?([\\s\\S]*?)```") == OK:
		var results = regex_code_block.search_all(formatted)

		for result in results:
			var language = result.get_string(1) if result.get_string(1) != "" else "gdscript"
			var code_content = result.get_string(2)
			var highlighted_code = _apply_syntax_highlighting(code_content, language)
			var full_match = result.get_string(0)

			# Simplified code block styling to prevent display issues
			var styled_code = "[bgcolor=#1e1e1e][color=#d4d4d4][font_size=12]" + \
				"[color=#569cd6][b] " + language.to_upper() + " [/b][/color]\n" + \
				highlighted_code + \
				"[/font_size][/color][/bgcolor]"

			formatted = formatted.replace(full_match, styled_code)

	# Format inline code with simplified styling
	var regex_inline_code = RegEx.new()
	if regex_inline_code.compile("`([^`]+)`") == OK:
		formatted = regex_inline_code.sub(formatted,
			"[color=#ce9178][code]$1[/code][/color]", true)

	# Enhanced text formatting with error handling
	formatted = _format_text_styles(formatted)
	formatted = _format_headers(formatted)
	formatted = _format_lists(formatted)
	formatted = _format_quotes(formatted)
	formatted = _format_links(formatted)

	return formatted

func _apply_syntax_highlighting(code: String, language: String) -> String:
	# Apply language-specific syntax highlighting
	match language.to_lower():
		"gdscript", "gd", _:
			return _highlight_gdscript(code)
		"python", "py":
			return _highlight_python(code)
		"javascript", "js":
			return _highlight_javascript(code)
		"json":
			return _highlight_json(code)

	return code

func _highlight_gdscript(code: String) -> String:
	var highlighted = code

	# GDScript keywords
	var keywords = ["func", "class", "extends", "var", "const", "signal", "enum",
					"if", "elif", "else", "for", "while", "match", "break", "continue",
					"return", "pass", "and", "or", "not", "in", "is", "as", "self",
					"true", "false", "null", "@tool", "@export", "@onready"]

	for keyword in keywords:
		var regex = RegEx.new()
		regex.compile("\\b" + keyword + "\\b")
		highlighted = regex.sub(highlighted, "[color=#569cd6]" + keyword + "[/color]", true)

	# Strings
	var string_regex = RegEx.new()
	string_regex.compile("\"([^\"\\\\]|\\\\.)*\"")
	highlighted = string_regex.sub(highlighted, "[color=#ce9178]$0[/color]", true)

	string_regex.compile("'([^'\\\\]|\\\\.)*'")
	highlighted = string_regex.sub(highlighted, "[color=#ce9178]$0[/color]", true)

	# Numbers
	var number_regex = RegEx.new()
	number_regex.compile("\\b\\d+(\\.\\d+)?\\b")
	highlighted = number_regex.sub(highlighted, "[color=#b5cea8]$0[/color]", true)

	# Comments
	var comment_regex = RegEx.new()
	comment_regex.compile("#.*$")
	highlighted = comment_regex.sub(highlighted, "[color=#6a9955]$0[/color]", true)

	# Function names
	var func_regex = RegEx.new()
	func_regex.compile("func\\s+(\\w+)")
	highlighted = func_regex.sub(highlighted, "func [color=#dcdcaa]$1[/color]", true)

	# Class names
	var class_regex = RegEx.new()
	class_regex.compile("class\\s+(\\w+)")
	highlighted = class_regex.sub(highlighted, "class [color=#4ec9b0]$1[/color]", true)

	return highlighted

func _highlight_python(code: String) -> String:
	var highlighted = code

	# Python keywords
	var keywords = ["def", "class", "import", "from", "if", "elif", "else", "for", "while",
					"try", "except", "finally", "with", "as", "return", "yield", "break",
					"continue", "pass", "and", "or", "not", "in", "is", "True", "False", "None"]

	for keyword in keywords:
		var regex = RegEx.new()
		regex.compile("\\b" + keyword + "\\b")
		highlighted = regex.sub(highlighted, "[color=#569cd6]" + keyword + "[/color]", true)

	# Strings
	var string_regex = RegEx.new()
	string_regex.compile("\"([^\"\\\\]|\\\\.)*\"")
	highlighted = string_regex.sub(highlighted, "[color=#ce9178]$0[/color]", true)

	# Comments
	var comment_regex = RegEx.new()
	comment_regex.compile("#.*$")
	highlighted = comment_regex.sub(highlighted, "[color=#6a9955]$0[/color]", true)

	return highlighted

func _highlight_javascript(code: String) -> String:
	var highlighted = code

	# JavaScript keywords
	var keywords = ["function", "var", "let", "const", "if", "else", "for", "while",
					"do", "switch", "case", "break", "continue", "return", "try", "catch",
					"finally", "throw", "new", "this", "true", "false", "null", "undefined"]

	for keyword in keywords:
		var regex = RegEx.new()
		regex.compile("\\b" + keyword + "\\b")
		highlighted = regex.sub(highlighted, "[color=#569cd6]" + keyword + "[/color]", true)

	# Strings
	var string_regex = RegEx.new()
	string_regex.compile("\"([^\"\\\\]|\\\\.)*\"")
	highlighted = string_regex.sub(highlighted, "[color=#ce9178]$0[/color]", true)

	# Comments
	var comment_regex = RegEx.new()
	comment_regex.compile("//.*$")
	highlighted = comment_regex.sub(highlighted, "[color=#6a9955]$0[/color]", true)

	return highlighted

func _highlight_json(code: String) -> String:
	var highlighted = code

	# JSON strings (keys and values)
	var string_regex = RegEx.new()
	string_regex.compile("\"([^\"\\\\]|\\\\.)*\"")
	highlighted = string_regex.sub(highlighted, "[color=#ce9178]$0[/color]", true)

	# JSON values
	var value_regex = RegEx.new()
	value_regex.compile("\\b(true|false|null)\\b")
	highlighted = value_regex.sub(highlighted, "[color=#569cd6]$0[/color]", true)

	# Numbers
	var number_regex = RegEx.new()
	number_regex.compile("\\b\\d+(\\.\\d+)?\\b")
	highlighted = number_regex.sub(highlighted, "[color=#b5cea8]$0[/color]", true)

	return highlighted

func _format_text_styles(text: String) -> String:
	var formatted = text

	# Bold text with enhanced styling
	var regex_bold = RegEx.new()
	if regex_bold.compile("\\*\\*([^*]+)\\*\\*") == OK:
		formatted = regex_bold.sub(formatted, "[b][color=#ffffff]$1[/color][/b]", true)

	# Italic text
	var regex_italic = RegEx.new()
	if regex_italic.compile("\\*([^*]+)\\*") == OK:
		formatted = regex_italic.sub(formatted, "[i][color=#d7ba7d]$1[/color][/i]", true)

	# Strikethrough
	var regex_strike = RegEx.new()
	if regex_strike.compile("~~([^~]+)~~") == OK:
		formatted = regex_strike.sub(formatted, "[s][color=#808080]$1[/color][/s]", true)

	return formatted

func _repeat_string(text: String, count: int) -> String:
	# Helper function to repeat a string (GDScript doesn't have string.repeat())
	var result = ""
	for i in range(count):
		result += text
	return result

func _format_headers(text: String) -> String:
	var formatted = text

	# Headers with simplified styling to prevent display issues
	var regex_h1 = RegEx.new()
	if regex_h1.compile("^# (.+)$") == OK:
		formatted = regex_h1.sub(formatted,
			"\n[font_size=18][b][color=#4fc1ff]$1[/color][/b][/font_size]\n", true)

	var regex_h2 = RegEx.new()
	if regex_h2.compile("^## (.+)$") == OK:
		formatted = regex_h2.sub(formatted,
			"\n[font_size=16][b][color=#9cdcfe]$1[/color][/b][/font_size]\n", true)

	var regex_h3 = RegEx.new()
	if regex_h3.compile("^### (.+)$") == OK:
		formatted = regex_h3.sub(formatted,
			"\n[font_size=14][b][color=#c586c0]$1[/color][/b][/font_size]\n", true)

	return formatted

func _format_lists(text: String) -> String:
	var formatted = text

	# Bullet points
	var regex_bullet = RegEx.new()
	if regex_bullet.compile("^- (.+)$") == OK:
		formatted = regex_bullet.sub(formatted, "[color=#569cd6]•[/color] $1", true)

	# Numbered lists
	var regex_numbered = RegEx.new()
	if regex_numbered.compile("^(\\d+)\\. (.+)$") == OK:
		formatted = regex_numbered.sub(formatted, "[color=#569cd6]$1.[/color] $2", true)

	return formatted

func _format_quotes(text: String) -> String:
	var formatted = text

	# Block quotes with simplified styling
	var regex_quote = RegEx.new()
	if regex_quote.compile("^> (.+)$") == OK:
		formatted = regex_quote.sub(formatted,
			"[color=#9cdcfe]> [/color][i][color=#d4d4d4]$1[/color][/i]", true)

	return formatted

func _format_links(text: String) -> String:
	var formatted = text

	# Markdown links [text](url)
	var regex_link = RegEx.new()
	if regex_link.compile("\\[([^\\]]+)\\]\\(([^\\)]+)\\)") == OK:
		formatted = regex_link.sub(formatted, "[color=#4fc1ff][u]$1[/u][/color]", true)

	# URLs
	var regex_url = RegEx.new()
	if regex_url.compile("https?://[^\\s]+") == OK:
		formatted = regex_url.sub(formatted, "[color=#4fc1ff][u]$0[/u][/color]", true)

	return formatted

func _is_code_response(response: String) -> bool:
	var code_indicators = ["func ", "class ", "extends ", "var ", "const ", "if ", "for ", "while ", "@tool", "signal "]
	for indicator in code_indicators:
		if indicator in response:
			return true
	return false

func _extract_code(response: String) -> String:
	# Try to extract code from markdown code blocks
	var regex = RegEx.new()
	regex.compile("```(?:gdscript|gd)?\\n?([\\s\\S]*?)```")
	var result = regex.search(response)
	if result:
		return result.get_string(1).strip_edges()

	# If no code blocks, return the whole response if it looks like code
	if _is_code_response(response):
		return response.strip_edges()

	return ""

func _on_apply_code():
	if current_generated_code.is_empty():
		return

	# Get the current script editor
	var script_editor = EditorInterface.get_script_editor()
	if script_editor:
		var current_editor = script_editor.get_current_editor()
		if current_editor:
			var text_editor = current_editor.get_base_editor()
			if text_editor:
				# Insert code at cursor position
				text_editor.insert_text_at_caret(current_generated_code)
				_add_to_chat("System", "Code applied to current script!", Color.YELLOW)
			else:
				_add_to_chat("Error", "No text editor found", Color.RED)
		else:
			_add_to_chat("Error", "No script editor open", Color.RED)
	else:
		_add_to_chat("Error", "Script editor not available", Color.RED)

func _on_explain_code():
	var selected_text = _get_selected_text()
	if selected_text.is_empty():
		_add_to_chat("System", "Please select some code to explain", Color.YELLOW)
		return

	_add_to_chat("You", "Explain this code: " + selected_text, Color.CYAN)
	send_button.disabled = true
	api_manager.explain_code(selected_text)

func _on_improve_code():
	var selected_text = _get_selected_text()
	if selected_text.is_empty():
		_add_to_chat("System", "Please select some code to improve", Color.YELLOW)
		return

	_add_to_chat("You", "Suggest improvements for: " + selected_text, Color.CYAN)
	send_button.disabled = true
	api_manager.suggest_improvements(selected_text)

func _get_selected_text() -> String:
	var script_editor = EditorInterface.get_script_editor()
	if script_editor:
		var current_editor = script_editor.get_current_editor()
		if current_editor:
			var text_editor = current_editor.get_base_editor()
			if text_editor:
				return text_editor.get_selected_text()
	return ""

func _on_help_pressed():
	if not setup_guide:
		var SetupGuide = load("res://addons/ai_coding_assistant/setup_guide.gd")
		if SetupGuide:
			setup_guide = SetupGuide.new()
			get_viewport().add_child(setup_guide)
		else:
			print("Failed to load setup guide script")
			return
	setup_guide.show_guide()

func _on_settings_pressed():
	if not settings_dialog:
		var AISettingsDialog = load("res://addons/ai_coding_assistant/settings_dialog.gd")
		if AISettingsDialog:
			settings_dialog = AISettingsDialog.new()
			settings_dialog.settings_changed.connect(_on_settings_changed)
			get_viewport().add_child(settings_dialog)
		else:
			print("Failed to load settings dialog script")
			return

	# Load current settings
	var current_settings = {
		"api_key": api_manager.api_key,
		"provider": api_manager.api_provider,
		"temperature": 0.7,
		"max_tokens": 2048,
		"auto_suggest": false,
		"save_history": true
	}
	settings_dialog.load_settings(current_settings)
	settings_dialog.popup_centered()

func _on_settings_changed(settings: Dictionary):
	api_manager.set_api_key(settings.get("api_key", ""))
	api_manager.set_provider(settings.get("provider", "gemini"))

	# Update UI to reflect changes
	var providers = ["gemini", "huggingface", "cohere"]
	var provider_index = providers.find(settings.get("provider", "gemini"))
	if provider_index >= 0:
		provider_option.selected = provider_index

	api_key_field.text = settings.get("api_key", "")

	# Save settings to file
	_save_settings(settings)

func _save_settings(settings: Dictionary):
	var config = ConfigFile.new()
	for key in settings:
		config.set_value("ai_assistant", key, settings[key])

	# Save UI state
	config.set_value("ui_state", "settings_collapsed", settings_collapsed)
	config.set_value("ui_state", "quick_actions_collapsed", quick_actions_collapsed)
	config.set_value("ui_state", "chat_word_wrap_enabled", chat_word_wrap_enabled)
	config.set_value("ui_state", "code_line_numbers_enabled", code_line_numbers_enabled)
	if main_splitter:
		config.set_value("ui_state", "splitter_offset", main_splitter.split_offset)

	config.save("user://ai_assistant_settings.cfg")

func _load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://ai_assistant_settings.cfg")
	if err == OK:
		var api_key = config.get_value("ai_assistant", "api_key", "")
		var provider = config.get_value("ai_assistant", "provider", "gemini")

		api_manager.set_api_key(api_key)
		api_manager.set_provider(provider)

		# Load UI state
		settings_collapsed = config.get_value("ui_state", "settings_collapsed", false)
		quick_actions_collapsed = config.get_value("ui_state", "quick_actions_collapsed", false)
		chat_word_wrap_enabled = config.get_value("ui_state", "chat_word_wrap_enabled", true)
		code_line_numbers_enabled = config.get_value("ui_state", "code_line_numbers_enabled", false)
		var splitter_offset = config.get_value("ui_state", "splitter_offset", 200)

		# Update UI
		if api_key_field:
			api_key_field.text = api_key
		var providers = ["gemini", "huggingface", "cohere"]
		var provider_index = providers.find(provider)
		if provider_index >= 0 and provider_option:
			provider_option.selected = provider_index

		# Apply UI state after a frame to ensure UI is ready
		call_deferred("_apply_ui_state", splitter_offset)

func _apply_ui_state(splitter_offset: int):
	if main_splitter:
		main_splitter.split_offset = splitter_offset
	_refresh_settings_section()
	_refresh_quick_actions_section()

	# Apply view preferences
	if chat_history:
		chat_history.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if chat_word_wrap_enabled else TextServer.AUTOWRAP_OFF
	if chat_word_wrap_button:
		chat_word_wrap_button.text = "↩" if chat_word_wrap_enabled else "→"
		chat_word_wrap_button.tooltip_text = "Word wrap: " + ("ON" if chat_word_wrap_enabled else "OFF")

	if code_output:
		code_output.gutters_draw_line_numbers = code_line_numbers_enabled  # Correct property name for Godot 4.x
	if code_line_numbers_button:
		code_line_numbers_button.text = "#" if code_line_numbers_enabled else "∅"
		code_line_numbers_button.tooltip_text = "Line numbers: " + ("ON" if code_line_numbers_enabled else "OFF")

	# Apply responsive design after UI state is loaded
	_apply_responsive_design()

# Keyboard shortcuts setup
func _setup_keyboard_shortcuts():
	# Enable input handling for the dock
	set_process_unhandled_key_input(true)

func _unhandled_key_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		var key_event = event as InputEventKey

		# Ctrl+C - Copy (when code output has focus)
		if key_event.ctrl_pressed and key_event.keycode == KEY_C:
			if code_output.has_focus():
				_on_copy_code()
				get_viewport().set_input_as_handled()

		# Ctrl+S - Save code (when code output has focus)
		elif key_event.ctrl_pressed and key_event.keycode == KEY_S:
			if code_output.has_focus():
				_on_save_code()
				get_viewport().set_input_as_handled()

		# Ctrl+A - Select all (when code output has focus)
		elif key_event.ctrl_pressed and key_event.keycode == KEY_A:
			if code_output.has_focus():
				code_output.select_all()
				get_viewport().set_input_as_handled()

		# Ctrl+L - Clear chat
		elif key_event.ctrl_pressed and key_event.keycode == KEY_L:
			_on_clear_chat()
			get_viewport().set_input_as_handled()

		# F1 - Help
		elif key_event.keycode == KEY_F1:
			_on_help_pressed()
			get_viewport().set_input_as_handled()

		# Escape - Clear input field
		elif key_event.keycode == KEY_ESCAPE:
			if input_field.has_focus():
				input_field.clear()
				get_viewport().set_input_as_handled()
