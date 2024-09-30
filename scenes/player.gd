extends Node2D

const tile_hover_packed = preload("res://scenes/ui/tile_hover_rect.tscn")
const TILE_HOVER_COLOR_VALID = Color("ffffff44")
const TILE_HOVER_COLOR_INVALID = Color("00000000") # Don't show invalid tiles for now


func move(to:Vector2i):
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(to) * Global.TILE_SIZE, 0.5)
	await tween.finished


# Not sure if this is where this logic really belongs
func draw_mouse_hover() -> void:
	var tile_global_pos = (Vector2i(get_global_mouse_position()) / Global.TILE_SIZE) * Global.TILE_SIZE
	
	Global.get_node("TileHoverRect").global_position = tile_global_pos
	
	if Global.is_floor_tile(Global.global_to_tile_position(tile_global_pos)):
		Global.get_node("TileHoverRect").color = TILE_HOVER_COLOR_VALID
	else:
		Global.get_node("TileHoverRect").color = TILE_HOVER_COLOR_INVALID

func _process(delta: float) -> void:
	draw_mouse_hover()
	
	
func take_damage():
	pass
	
