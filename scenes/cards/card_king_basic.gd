extends CardResource
class_name CardKingBasic

func _init() -> void:
	action_count = 1
	card_name = "King"
	description = "If this card is discarded, you die! Move action: " +\
		"Move to any adjacent tile. Attack action: Attack any adjacent enemy."
	

func get_available_positions(player_pos:Vector2i) -> Array[Vector2i]:
	var ret:Array[Vector2i] = []
	const DIAG_POS = Vector2(1,1)
	var offsets = [
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT,
		
		Global.rotate_vec2i(DIAG_POS, 0),
		Global.rotate_vec2i(DIAG_POS, 90),
		Global.rotate_vec2i(DIAG_POS, 180),
		Global.rotate_vec2i(DIAG_POS, 270),
	]
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile):
			ret.append(target_tile)
	return ret

func on_discard() -> void:
	assert(false, "You died! Currently there is no death functionality so I'm just gonna kill your game.")
