extends Node2D

var permissao_matar: bool = false
var inimigo_na_mira: Node2D = null
var quant_javali: int = 0
var DISTANCIA_FIXA = 21.0
var _can_attack: bool = true
var attack_timer = null
@onready var sprite = $Arma/AnimatedSprite2D
@onready var sprite_perso = $CharacterBody2D/anim

const perso_script = preload("res://character.gd")

@export var _animatedgun: AnimationPlayer = null
@export var sprite_tiro: AnimatedSprite2D

func _ready() -> void:
	sprite.play("default")
	sprite_tiro.play("default")

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
			#sprite_tiro.flip_v = true

		else:
			sprite.flip_v = false
			#sprite_tiro.flip_v = true
	
	if Input.is_action_just_pressed("atirar"):
		permissao_matar = true
		if _can_attack:
			fire(direction)

func fire(direction: Vector2):
	_can_attack = false
	sprite_tiro.visible = true
	permissao_matar = true
	sprite.play("shoot")
	_animatedgun.play("shoot")
	sprite_tiro.play("shoot")

	# Mata o inimigo aqui, durante o tiro
	if inimigo_na_mira != null and inimigo_na_mira.is_inside_tree():
		inimigo_na_mira.queue_free()
		inimigo_na_mira = null
		print("Inimigo abatido!")

	await get_tree().create_timer(0.4).timeout
	sprite.play("default")
	sprite_tiro.visible = false
	_can_attack = true



func _on_tiro_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		inimigo_na_mira = body
		print("Inimigo detectado!")


func _on_tiro_area_body_exited(body: Node2D) -> void:
	if body == inimigo_na_mira:
		inimigo_na_mira = null
		print("Inimigo saiu da mira.")
