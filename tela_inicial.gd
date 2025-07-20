extends Control


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://jogo/main.tscn")


func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/creditos.tscn")
