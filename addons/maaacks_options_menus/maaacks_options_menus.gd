@tool
class_name MaaacksOptionsMenusPlugin
extends EditorPlugin

const APIClient = preload("res://addons/maaacks_options_menus/utilities/api_client.gd")
const DownloadAndExtract = preload("res://addons/maaacks_options_menus/utilities/download_and_extract.gd")

const PLUGIN_NAME = "Maaack's Options Menus"
const PROJECT_SETTINGS_PATH = "maaacks_options_menus/"

const EXAMPLES_RELATIVE_PATH = "examples/"
const MAIN_SCENE_RELATIVE_PATH = "scenes/menus/options_menu/master_options_menu_with_tabs.tscn"
const OVERRIDE_RELATIVE_PATH = "installer/override.cfg"
const UID_PREG_MATCH = r'uid="uid:\/\/[0-9a-z]+" '
const WINDOW_OPEN_DELAY : float = 0.5
const RUNNING_CHECK_DELAY : float = 0.25
const RESAVING_DELAY : float = 1.0
const OPEN_EDITOR_DELAY : float = 0.1
const MAX_PHYSICS_FRAMES_FROM_START : int = 20
const AVAILABLE_TRANSLATIONS : Array = ["en", "fr"]
const RAW_COPY_EXTENSIONS : Array = ["gd", "md", "txt"]
const OMIT_COPY_EXTENSIONS : Array = ["uid"]
const REPLACE_CONTENT_EXTENSIONS : Array = ["gd", "tscn", "tres", "md"]

var update_plugin_tool_string : String

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func get_plugin_path() -> String:
	return get_script().resource_path.get_base_dir() + "/"

func get_plugin_examples_path() -> String:
	return get_plugin_path() + EXAMPLES_RELATIVE_PATH

func get_copy_path() -> String:
	var copy_path = ProjectSettings.get_setting(PROJECT_SETTINGS_PATH + "copy_path", get_plugin_examples_path())
	if not copy_path.ends_with("/"):
		copy_path += "/"
	return copy_path

func _open_play_opening_confirmation_dialog(target_path : String) -> void:
	var play_confirmation_scene : PackedScene = load(get_plugin_path() + "installer/play_opening_confirmation_dialog.tscn")
	var play_confirmation_instance : ConfirmationDialog = play_confirmation_scene.instantiate()
	play_confirmation_instance.confirmed.connect(_run_opening_scene.bind(target_path))
	add_child(play_confirmation_instance)

func _open_delete_examples_confirmation_dialog(target_path : String) -> void:
	var delete_confirmation_scene : PackedScene = load(get_plugin_path() + "installer/delete_examples_confirmation_dialog.tscn")
	var delete_confirmation_instance : ConfirmationDialog = delete_confirmation_scene.instantiate()
	delete_confirmation_instance.confirmed.connect(_delete_source_examples_directory.bind(target_path))
	add_child(delete_confirmation_instance)

func _open_delete_examples_short_confirmation_dialog() -> void:
	var delete_confirmation_scene : PackedScene = load(get_plugin_path() + "installer/delete_examples_short_confirmation_dialog.tscn")
	var delete_confirmation_instance : ConfirmationDialog = delete_confirmation_scene.instantiate()
	delete_confirmation_instance.confirmed.connect(_delete_source_examples_directory)
	add_child(delete_confirmation_instance)

func _run_opening_scene(target_path : String) -> void:
	var opening_scene_path = target_path + MAIN_SCENE_RELATIVE_PATH
	EditorInterface.play_custom_scene(opening_scene_path)
	var timer: Timer = Timer.new()
	var callable := func() -> void:
		if EditorInterface.is_playing_scene(): return
		timer.stop()
		_open_delete_examples_confirmation_dialog(target_path)
		timer.queue_free()
	timer.timeout.connect(callable)
	add_child(timer)
	timer.start(RUNNING_CHECK_DELAY)

func _delete_directory_recursive(dir_path : String) -> void:
	if not dir_path.ends_with("/"):
		dir_path += "/"
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var error : Error
		while file_name != "" and error == 0:
			var relative_path = dir_path.trim_prefix(get_plugin_examples_path())
			var full_file_path = dir_path + file_name
			if dir.current_is_dir():
				_delete_directory_recursive(full_file_path)
			else:
				error = dir.remove(file_name)
			file_name = dir.get_next()
		if error:
			push_error("plugin error - deleting path: %s" % error)
	else:
		push_error("plugin error - accessing path: %s" % dir)
	dir.remove(dir_path)

func _delete_source_examples_directory(_target_path : String = "") -> void:
	var examples_path = get_plugin_examples_path()
	var dir := DirAccess.open("res://")
	if dir.dir_exists(examples_path):
		_delete_directory_recursive(examples_path)
		EditorInterface.get_resource_filesystem().scan()
		remove_tool_menu_item("Copy " + _get_plugin_name() + " Examples...")
		remove_tool_menu_item("Delete " + _get_plugin_name() + " Examples...")

func _replace_file_contents(file_path : String, target_path : String) -> void:
	var extension : String = file_path.get_extension()
	if extension not in REPLACE_CONTENT_EXTENSIONS:
		return
	var file = FileAccess.open(file_path, FileAccess.READ)
	var regex = RegEx.new()
	regex.compile(UID_PREG_MATCH)
	if file == null:
		push_error("plugin error - null file: `%s`" % file_path)
		return
	var original_content = file.get_as_text()
	var replaced_content = regex.sub(original_content, "", true)
	replaced_content = replaced_content.replace(get_plugin_examples_path().trim_prefix("res://"), target_path.trim_prefix("res://"))
	file.close()
	if replaced_content == original_content: return
	file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(replaced_content)
	file.close()

func _save_resource(resource_path : String, resource_destination : String, whitelisted_extensions : PackedStringArray = []) -> Error:
	var extension : String = resource_path.get_extension()
	if whitelisted_extensions.size() > 0:
		if not extension in whitelisted_extensions:
			return OK
	if extension == "import":
		# skip import files
		return OK
	var file_object = load(resource_path)
	if file_object is Resource:
		var possible_extensions = ResourceSaver.get_recognized_extensions(file_object)
		if possible_extensions.has(extension):
			return ResourceSaver.save(file_object, resource_destination, ResourceSaver.FLAG_CHANGE_PATH)
		else:
			return ERR_FILE_UNRECOGNIZED
	else:
		return ERR_FILE_UNRECOGNIZED
	return OK

func _raw_copy_file_path(file_path : String, destination_path : String) -> Error:
	var dir := DirAccess.open("res://")
	var error := dir.copy(file_path, destination_path)
	return error

func _copy_override_file() -> void:
	var override_path : String = get_plugin_path() + OVERRIDE_RELATIVE_PATH
	_raw_copy_file_path(override_path, "res://"+override_path.get_file())

func _copy_file_path(file_path : String, destination_path : String, target_path : String) -> Error:
	var error : Error
	if file_path.get_extension() in OMIT_COPY_EXTENSIONS:
		return error
	if file_path.get_extension() in RAW_COPY_EXTENSIONS:
		error = _raw_copy_file_path(file_path, destination_path)
	else:
		error = _save_resource(file_path, destination_path)
		if error == ERR_FILE_UNRECOGNIZED:
			error = _raw_copy_file_path(file_path, destination_path)
	if not error:
		_replace_file_contents(destination_path, target_path)
	return error

func _copy_directory_path(dir_path : String, target_path : String) -> void:
	if not dir_path.ends_with("/"):
		dir_path += "/"
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var error : Error
		while file_name != "" and error == 0:
			var relative_path = dir_path.trim_prefix(get_plugin_examples_path())
			var destination_path = target_path + relative_path + file_name
			var full_file_path = dir_path + file_name
			if dir.current_is_dir():
				if not dir.dir_exists(destination_path):
					error = dir.make_dir(destination_path)
				_copy_directory_path(full_file_path, target_path)
			else:
				error = _copy_file_path(full_file_path, destination_path, target_path)
			file_name = dir.get_next()
		if error:
			push_error("plugin error - copying path: %s" % error)
	else:
		push_error("plugin error - accessing path: %s" % dir_path)

func _delayed_play_opening_confirmation_dialog(target_path : String) -> void:
	var timer: Timer = Timer.new()
	var callable := func():
		timer.stop()
		_open_play_opening_confirmation_dialog(target_path)
		timer.queue_free()
	timer.timeout.connect(callable)
	add_child(timer)
	timer.start(WINDOW_OPEN_DELAY)

func _wait_for_scan_and_delay_next_prompt(target_path : String) -> void:
	var timer: Timer = Timer.new()
	var callable := func():
		if EditorInterface.get_resource_filesystem().is_scanning(): return
		timer.stop()
		_delayed_play_opening_confirmation_dialog(target_path)
		timer.queue_free()
	timer.timeout.connect(callable)
	add_child(timer)
	timer.start(RUNNING_CHECK_DELAY)

func _delayed_saving_and_next_prompt(target_path : String) -> void:
	var timer: Timer = Timer.new()
	var callable := func():
		timer.stop()
		EditorInterface.save_all_scenes()
		EditorInterface.get_resource_filesystem().scan()
		_wait_for_scan_and_delay_next_prompt(target_path)
		timer.queue_free()
	timer.timeout.connect(callable)
	add_child(timer)
	timer.start(RESAVING_DELAY)

func _add_translations() -> void:
	var dir := DirAccess.open("res://")
	var translations : PackedStringArray = ProjectSettings.get_setting("internationalization/locale/translations", [])
	for available_translation in AVAILABLE_TRANSLATIONS:
		var translation_path = get_plugin_path() + ("base/translations/menus_translations.%s.translation" % available_translation)
		if dir.file_exists(translation_path) and translation_path not in translations:
			translations.append(translation_path)
	ProjectSettings.set_setting("internationalization/locale/translations", translations)

func _copy_to_directory(target_path : String) -> void:
	ProjectSettings.set_setting(PROJECT_SETTINGS_PATH + "copy_path", target_path)
	ProjectSettings.save()
	if not target_path.ends_with("/"):
		target_path += "/"
	_copy_directory_path(get_plugin_examples_path(), target_path)
	_copy_override_file()
	_delayed_saving_and_next_prompt(target_path)

func _open_input_icons_dialog() -> void:
	var input_icons_scene : PackedScene = load(get_plugin_path() + "installer/kenney_input_prompts_installer.tscn")
	var input_icons_instance = input_icons_scene.instantiate()
	input_icons_instance.copy_dir_path = get_copy_path()
	add_child(input_icons_instance)

func _open_path_dialog() -> void:
	var destination_scene : PackedScene = load(get_plugin_path() + "installer/destination_dialog.tscn")
	var destination_instance : FileDialog = destination_scene.instantiate()
	destination_instance.dir_selected.connect(_copy_to_directory)
	add_child(destination_instance)

func _open_confirmation_dialog() -> void:
	var confirmation_scene : PackedScene = load(get_plugin_path() + "installer/copy_confirmation_dialog.tscn")
	var confirmation_instance : ConfirmationDialog = confirmation_scene.instantiate()
	confirmation_instance.confirmed.connect(_open_path_dialog)
	add_child(confirmation_instance)

func _open_check_plugin_version() -> void:
	if ProjectSettings.has_setting(PROJECT_SETTINGS_PATH + "disable_update_check"):
		if ProjectSettings.get_setting(PROJECT_SETTINGS_PATH + "disable_update_check"):
			return
	else:
		ProjectSettings.set_setting(PROJECT_SETTINGS_PATH + "disable_update_check", false)
		ProjectSettings.save()
	var check_version_scene : PackedScene = load(get_plugin_path() + "installer/check_plugin_version.tscn")
	var check_version_instance : Node = check_version_scene.instantiate()
	check_version_instance.auto_start = true
	check_version_instance.new_version_detected.connect(_add_update_plugin_tool_option)
	add_child(check_version_instance)

func _open_update_plugin() -> void:
	var update_plugin_scene : PackedScene = load(get_plugin_path() + "installer/update_plugin.tscn")
	var update_plugin_instance : Node = update_plugin_scene.instantiate()
	update_plugin_instance.auto_start = true
	update_plugin_instance.update_completed.connect(_remove_update_plugin_tool_option)
	add_child(update_plugin_instance)

func _add_update_plugin_tool_option(new_version : String) -> void:
	update_plugin_tool_string = "Update %s to v%s..." % [_get_plugin_name(), new_version]
	add_tool_menu_item(update_plugin_tool_string, _open_update_plugin)

func _remove_update_plugin_tool_option() -> void:
	if update_plugin_tool_string.is_empty(): return
	remove_tool_menu_item(update_plugin_tool_string)
	update_plugin_tool_string = ""

func _show_plugin_dialogues() -> void:
	if ProjectSettings.has_setting(PROJECT_SETTINGS_PATH + "disable_install_wizard") :
		if ProjectSettings.get_setting(PROJECT_SETTINGS_PATH + "disable_install_wizard") :
			return
	_open_confirmation_dialog()
	ProjectSettings.set_setting(PROJECT_SETTINGS_PATH + "disable_install_wizard", true)
	ProjectSettings.save()

func _resave_if_recently_opened() -> void:
	if Engine.get_physics_frames() < MAX_PHYSICS_FRAMES_FROM_START:
		var timer: Timer = Timer.new()
		var callable := func():
			if Engine.get_frames_per_second() >= 10:
				timer.stop()
				EditorInterface.save_scene()
				timer.queue_free()
		timer.timeout.connect(callable)
		add_child(timer)
		timer.start(OPEN_EDITOR_DELAY)

func _add_tool_options() -> void:
	var examples_path = get_plugin_examples_path()
	var dir := DirAccess.open("res://")
	if dir.dir_exists(examples_path):
		add_tool_menu_item("Copy " + _get_plugin_name() + " Examples...", _open_path_dialog)
		add_tool_menu_item("Delete " + _get_plugin_name() + " Examples...", _open_delete_examples_short_confirmation_dialog)
	add_tool_menu_item("Use Input Icons for " + _get_plugin_name() + "...", _open_input_icons_dialog)
	_open_check_plugin_version()

func _remove_tool_options() -> void:
	var examples_path = get_plugin_examples_path()
	var dir := DirAccess.open("res://")
	if dir.dir_exists(examples_path):
		remove_tool_menu_item("Copy " + _get_plugin_name() + " Examples...")
		remove_tool_menu_item("Delete " + _get_plugin_name() + " Examples...")
	remove_tool_menu_item("Use Input Icons for " + _get_plugin_name() + "...")
	_remove_update_plugin_tool_option()

func _enter_tree() -> void:
	add_autoload_singleton("AppConfig", get_plugin_path() + "base/scenes/autoloads/app_config.tscn")
	_add_tool_options()
	_add_translations()
	_show_plugin_dialogues()
	_resave_if_recently_opened()

func _exit_tree() -> void:
	remove_autoload_singleton("AppConfig")
	_remove_tool_options()
