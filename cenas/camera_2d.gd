extends Camera2D

@export var max_shake: float = 10.0
@export var shake_fade: float = 10.0

@export var player: Node2D

var desired_offset: Vector2
var min_offset = -100
var max_offset = 100

var _shake_strengt: float = 0.0

func trigger_shake() -> void:
	_shake_strengt = max_shake

func _process(delta: float) -> void:
	desired_offset = (get_global_mouse_position() - position) * 0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset, max_offset)

	if _shake_strengt > 0:
		_shake_strengt = lerp(_shake_strengt, 0.0, shake_fade * delta)
		offset = Vector2(randf_range(-_shake_strengt, _shake_strengt), randf_range(-_shake_strengt, _shake_strengt))
		
	global_position = player.global_position + desired_offset
