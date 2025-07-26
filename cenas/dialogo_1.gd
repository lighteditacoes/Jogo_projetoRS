extends Node2D
class_name DialogoInicial

const _DIALOG_SCREEN: PackedScene = preload("res://cenas/dialog_screen.tscn")

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://personagem/Gaucho_3.png",
		"dialog": "Bah, piá, esses javalis tão destruindo nossa fazenda!",
		"title": "Veio Fredolino"
	},
	
	1: {
		"faceset": "res://personagem/Gaucho_3.png",
		"dialog": "Preciso que tu me ajude a acabar com eles… já tô meio enferrujado pra esse tipo de coisa.",
		"title": "Veio Fredolino"
	},
	
	2: {
		"faceset": "res://personagem/gaucho face.png",
		"dialog": "Pode deixar, vô, vou cuidar disso.",
		"title": "Gaúcho"
	},
	
	3: {
		"faceset": "res://personagem/Gaucho_3.png",
		"dialog": "Confio em ti, guri.",
		"title": "Veio Fredolino"
	},
	
	4: {
		"faceset": "res://personagem/Gaucho_3.png",
		"dialog": "Vai com tudo!",
		"title": "Veio Fredolino"
	},
	
	5: {
		"faceset": "res://personagem/gaucho face.png",
		"dialog": "Bah, tchê.",
		"title": "Gaúcho"
	},
}

@export_category("Objects")
@export var _hud: CanvasLayer = null
@export var _gaucho: AnimatedSprite2D = null
@export var _vovo: AnimatedSprite2D = null

func _ready() -> void:
	_gaucho.play("default")
	_vovo.play("default")
	
	var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
	_new_dialog.data = _dialog_data
	_hud.add_child(_new_dialog)
