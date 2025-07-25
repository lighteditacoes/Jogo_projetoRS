extends Node2D

var _timer: Timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global_position.x = 4000000
		body.velocidade = 350.0
		await get_tree().create_timer(7.0).timeout
		body.velocidade = 200.0
		queue_free()
