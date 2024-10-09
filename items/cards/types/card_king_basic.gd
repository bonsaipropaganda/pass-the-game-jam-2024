class_name CardKingBasic extends CardResource

func _init() -> void:
	card_name = "King"
	description = "If this card is discarded, you die! Move action: " +\
		"Move to any adjacent tile. Attack action: Attack any adjacent enemy."

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i(1,0), ## RIGHT
		Vector2i(1,1), ## DOWNRIGHT
		Vector2i(0,1), ## DOWN
		Vector2i(-1,1), ## DOWNLEFT
		Vector2i(-1,0), ## LEFT
		Vector2i(-1,-1), ## UPLEFT
		Vector2i(0,-1), ## UP
		Vector2i(1,-1) ## UPRIGHT
	]
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile) or Global.is_chest_on_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords

func on_discard() -> void:
	assert(false, "You died! Currently there is no death functionality so I'm just gonna kill your game.")
