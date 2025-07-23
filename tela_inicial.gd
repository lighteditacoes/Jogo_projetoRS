extends Control



func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/vila.tscn")


func _on_opcoes_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/maaacks_options_menus/base/scenes/menus/options_menu/master_options_menu_with_tabs.tscn")


func _on_como_jogar_pressed() -> void:
	pass # Replace with function body.


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/creditos.tscn")


func _on_sair_pressed() -> void:
	pass # Replace with function body.
