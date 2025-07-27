extends Node2D

var DISTANCIA_FIXA = 21.0
var _can_attack: bool = true
var quant_javali: int = 0

@onready var contador_kill: Label = $hud/Control/container/kills_container/contador_kill
@onready var sprite = $Arma/AnimatedSprite2D
@onready var sprite_perso = $CharacterBody2D/anim
@onready var tiro_area = $Arma/TiroArea

@export var _animatedgun: AnimationPlayer = null
@export var sprite_tiro: AnimatedSprite2D
@export var _som_tiro: AudioStreamPlayer
@export var _javali_morrendo: AudioStreamPlayer

func _ready() -> void:
	sprite.play("default")
	sprite_tiro.play("default")
	tiro_area.monitoring = true  # Garante que a área esteja monitorando

func _process(delta):
	var player_pos = get_parent().global_position
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - player_pos).normalized()

	if _can_attack:
		rotation = direction.angle()
		global_position = player_pos + direction * DISTANCIA_FIXA
		sprite.flip_v = direction.x < 0

		if Input.is_action_just_pressed("atirar"):
			fire(direction)
			_som_tiro.play()
			
	if quant_javali == 10:
		await get_tree().create_timer(0.5).timeout
		Globals.cont_kill = 0
		get_tree().change_scene_to_file("res://cenas/TESTE_WIN.tscn")


func fire(direction: Vector2) -> void:
	_can_attack = false
	sprite_tiro.visible = true
	sprite.play("shoot")
	_animatedgun.play("shoot")
	sprite_tiro.play("shoot")
	

	await get_tree().process_frame  # Espera um frame para garantir atualização do Area2D

	var corpos = tiro_area.get_overlapping_bodies()
	print("Corpos detectados: ", corpos.size())

	for corpo in corpos:
		if corpo.is_in_group("enemy"):
			print("Inimigo abatido: ", corpo.name)
			corpo.queue_free()
			_javali_morrendo.play()
			quant_javali += 1
			Globals.cont_kill = quant_javali

	await get_tree().create_timer(0.4).timeout
	sprite.play("default")
	sprite_tiro.visible = false
	_can_attack = true
