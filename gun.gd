extends Node2D

var DISTANCIA_FIXA = 21.0
var _can_attack: bool = true
var attack_timer = null
@onready var sprite = $Arma/AnimatedSprite2D
@onready var sprite_perso = $CharacterBody2D/anim
const perso_script = preload("res://character.gd")

@export var _animatedgun: AnimationPlayer = null

func _ready() -> void:
	sprite.play("default")

func _process(delta):
	var player_pos = get_parent().global_position
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - player_pos).normalized()
	if _can_attack:
		mouse_pos = get_global_mouse_position()
		direction = (mouse_pos - player_pos).normalized()
		rotation = direction.angle()
		
		global_position = player_pos + direction * DISTANCIA_FIXA
	
		if direction.x < 0:
			sprite.flip_v = true

		else:
			sprite.flip_v = false
	
	if Input.is_action_just_pressed("atirar"):
		if _can_attack:
			fire(direction)

func fire(direction: Vector2):
	_can_attack = false
	sprite.play("shoot")
	_animatedgun.play("shoot")
	await get_tree().create_timer(1.2).timeout
	sprite.play("default")
	_can_attack = true
