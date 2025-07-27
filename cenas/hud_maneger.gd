extends Control

@onready var contador_timer: Label = $container/timer_container/contador_timer
@onready var contador_kill: Label = $container/kills_container/contador_kill
@onready var timer: Timer = $timer

var minutos: int = 0
var segundos: int = 0
@export_range(0,2) var default_minutos = 1
@export_range(0, 59) var default_segundos = 0

func _ready() -> void:
	reset_timer()
	contador_kill.text = str("%02d" % Globals.cont_kill)
	contador_timer.text = str("%02d" % default_minutos + ":" + "%02d" % default_segundos)



func _process(delta: float) -> void:
	contador_kill.text = str("%02d" % Globals.cont_kill)
	
	if minutos == 0 and segundos == 0:
		Globals.cont_kill = 0
		get_tree().paused = true
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://cenas/game_over.tscn")


func _on_timer_timeout() -> void:
	if segundos == 0 and minutos > 0:
		minutos -= 1
		segundos = 60
	segundos -= 1

	contador_timer.text = str("%02d" % minutos + ":" + "%02d" % segundos)


func reset_timer():
	minutos = default_minutos
	segundos = default_segundos
