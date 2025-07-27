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

	move_and_slide()
	if velocity == Vector2(0,0):
		animacao_javali.play("idle")
	elif velocity != Vector2(0,0):
		animacao_javali.play("run")

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


func _on_area_mortal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("é para morrer")
		body.queue_free()
		Globals.cont_kill = 0
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file("res://cenas/game_over.tscn")
		
