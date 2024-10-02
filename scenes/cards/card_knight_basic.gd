extends CardResource
class_name CardKnightBasic

func _init() -> void:
	action_count = 1
	card_name = "Knight"
	description = "Move action: Move to tile in L-shape. Attack action: Attack tile in L-shape."


func get_available_positions(player_pos:Vector2i) -> Array[Vector2i]:
	var ret:Array[Vector2i] = []
	const L1 = Vector2(2,1)
	const L2 = Vector2(2,-1)
	var offsets = [
		Global.rotate_vec2i(L1, 0),
		Global.rotate_vec2i(L1, 90),
		Global.rotate_vec2i(L1, 180),
		Global.rotate_vec2i(L1, 270),
		
		Global.rotate_vec2i(L2, 0),
		Global.rotate_vec2i(L2, 90),
		Global.rotate_vec2i(L2, 180),
		Global.rotate_vec2i(L2, 270),
	]
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile):
			ret.append(target_tile)
	return ret
