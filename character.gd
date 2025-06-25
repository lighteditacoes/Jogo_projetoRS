extends CharacterBody2D

var velocidade: float = 400.0
var direcao_movimento: Vector2 = Vector2.ZERO
var gun_scene = preload("res://gun.tscn")
var gun: Node2D
var can_move: bool = true

@export var _animatedsprite: AnimatedSprite2D

func _ready():
	gun = gun_scene.instantiate()
	add_child(gun)
	
func _process(delta):
	if can_move:
		movimentar_jogador()
	_animate()

func movimentar_jogador():
	direcao_movimento = Vector2.ZERO
	if Input.is_action_pressed("andar_direita"):
		direcao_movimento.x += 1
	if Input.is_action_pressed("andar_esquerda"):
		direcao_movimento.x -= 1
	if Input.is_action_pressed("andar_cima"):
		direcao_movimento.y -= 1
	if Input.is_action_pressed("andar_baixo"):
		direcao_movimento.y += 1

	velocity = direcao_movimento.normalized() * velocidade
	move_and_slide()

func _animate() -> void:
	var player_pos = global_position
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - player_pos).normalized()
	
	if direction.x > 0:
		_animatedsprite.flip_h = false
	elif direction.x < 0:
		_animatedsprite.flip_h = true
	else:
		_animatedsprite.flip_h = false
		
	if velocity == Vector2(0,0):
		_animatedsprite.play("idle")
	#elif velocity != Vector2(0,0):
		#_animatedsprite.play("run")
