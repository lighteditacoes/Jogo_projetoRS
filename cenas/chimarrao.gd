extends Node2D

var _timer: Timer
var _particulas = preload("res://cenas/particulas_chimarrao.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var particulas_instancia = _particulas.instantiate()
		global_position.x = 4000000
		body.velocidade = 350.0
		body.add_child(particulas_instancia)
		await get_tree().create_timer(7.0).timeout
		body.velocidade = 200.0
		body.remove_child(particulas_instancia)
		queue_free()
