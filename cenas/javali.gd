extends CharacterBody2D

@export var velocidade: float = 100.0

var player: Node2D = null
var seguindo_player: bool = false
@export var animacao_javali: AnimatedSprite2D
var life: int = 30

func _physics_process(delta: float) -> void:
	
	if seguindo_player and player:
		var direcao = (player.global_position - global_position).normalized()
		if direcao.x < 0:
			animacao_javali.flip_h = true
		else:
			animacao_javali.flip_h = false
			
		velocity = direcao * velocidade
	else:
		velocity = Vector2.ZERO
		animacao_javali.play("idle")

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		seguindo_player = true
		player = body
		print("Player detectado!")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		seguindo_player = false
		player = null
		print("Player saiu da área!")
