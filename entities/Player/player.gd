extends Node2D

const tile_hover_packed = preload("res://ui/terrain/tile_hover_rect.tscn")
const TILE_HOVER_COLOR_VALID = Color("ffffff44")
const TILE_HOVER_COLOR_INVALID = Color("00000000") # Don't show invalid tiles for now

var inventory: Inventory = Inventory.new()

func move(to:Vector2i):
	AudioManager.sfx_play(AudioManager.sfx_enum.FOOTSTEPS)
	var tween = create_tween()
	var target_position:= Vector2(to) * C.TILE_SIZE + (Vector2.ONE * C.TILE_SIZE / 2.0)
	var distance = global_position.distance_to(target_position)
	tween.tween_property(self, "global_position", target_position, distance*0.01)
	await tween.finished


# Not sure if this is where this logic really belongs
var last_tile_global_pos:Vector2i
func draw_mouse_hover() -> void:
	var tile_global_pos = (Vector2i(get_global_mouse_position()) / C.TILE_SIZE) * C.TILE_SIZE
	
	Global.get_node("TileHoverRect").global_position = tile_global_pos
	
	if Global.is_floor_tile(Utils.global_pos_to_coord(tile_global_pos)):
		Global.get_node("TileHoverRect").color = TILE_HOVER_COLOR_VALID
		
		if tile_global_pos != last_tile_global_pos:
			#if annoying, try lowering the volume (third arg)
			AudioManager.sfx_play(AudioManager.sfx_enum.SELECT, 0.2, -12.0, 9.0)
		
	else:
		Global.get_node("TileHoverRect").color = TILE_HOVER_COLOR_INVALID
	last_tile_global_pos = tile_global_pos

func _process(_delta: float) -> void:
	draw_mouse_hover()
	
	
func take_damage():
	SignalBus.player_takes_damage.emit()
	
func attack() -> void:
	$AnimationPlayer2.play("attack")
	AudioManager.sfx_play(AudioManager.sfx_enum.ATTACK)
