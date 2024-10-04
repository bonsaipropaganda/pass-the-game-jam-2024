class_name CardKnightBasic extends CardResource

func _init() -> void:
	card_name = "Knight"
	description = "Move action: Move to tile in L-shape. Attack action: Attack tile in L-shape."

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = Utils.get_target_rotations_with_mirror(Vector2i(2,1)) # gets all 8 offsets
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords
