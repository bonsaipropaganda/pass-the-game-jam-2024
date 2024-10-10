extends Node2D

const tile_hover_packed = preload("res://ui/terrain/tile_hover_rect.tscn")
const TILE_HOVER_COLOR_VALID = Color("ffffff44")
const TILE_HOVER_COLOR_INVALID = Color("00000000") # Don't show invalid tiles for now

var inventory: Inventory = Inventory.new()

func move(to:Vector2i):
	var tween = create_tween()
	var target_position:= Vector2(to) * C.TILE_SIZE + (Vector2.ONE * C.TILE_SIZE / 2.0)
	var distance = global_position.distance_to(target_position)
	tween.tween_property(self, "global_position", target_position, distance*0.01)
	await tween.finished


# Not sure if this is where this logic really belongs
func draw_mouse_hover() -> void:
	var tile_global_pos = (Vector2i(get_global_mouse_position()) / C.TILE_SIZE) * C.TILE_SIZE
	
	Global.get_node("TileHoverRect").global_position = tile_global_pos
	
	if Global.is_floor_tile(Utils.global_pos_to_coord(tile_global_pos)):
		Global.get_node("TileHoverRect").color = TILE_HOVER_COLOR_VALID
	else:
		Global.get_node("TileHoverRect").color = TILE_HOVER_COLOR_INVALID


func _process(delta: float) -> void:
	draw_mouse_hover()
	
	
func take_damage():
	SignalBus.player_takes_damage.emit()
	
