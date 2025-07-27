extends Camera2D

var desired_offset: Vector2
var min_offset = -50
var max_offset = 50

@export var _tilemap: TileMapLayer

func _ready() -> void:
	camera_limits()
	

func _process(delta: float) -> void:
	desired_offset = (get_global_mouse_position() - position)*0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.x = clamp(desired_offset.y, min_offset / 4.0, max_offset / 4.0)
	
	global_position = get_parent().get_node("CharacterBody2D").global_position + desired_offset
	
func camera_limits():
	if not _tilemap:
		return
		
	var used_rect: Rect2i = _tilemap.get_used_rect()
	var tile_map_size := _tilemap.tile_set.get_tile_size()
	
	limit_left = used_rect.position.x
	limit_top = used_rect.position.y * tile_map_size.y
	limit_right = (used_rect.position.x + used_rect.size.x) * tile_map_size.x
	limit_bottom = (used_rect.position.y + used_rect.size.y) * tile_map_size.y
