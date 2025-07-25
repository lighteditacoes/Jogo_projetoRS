extends Control


func _on_yes_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/vila.tscn")
	
func _on_no_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/tela_inicial.tscn")
