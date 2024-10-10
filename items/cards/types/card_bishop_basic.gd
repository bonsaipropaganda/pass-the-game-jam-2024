class_name CardBishopBasic extends CardResource

func _init() -> void:
	card_name = "Bishop"
	description = """[color=cyan]Move Shape:[/color] 
	Diagnonal (max 3). 
[color=pink]Attack Shape:[/color] 
	Diagnonal (max 3)."""

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i(1,1),
		Vector2i(-1,1),
		Vector2i(1,-1),
		Vector2i(-1,-1),
		Vector2i(2,2),
		Vector2i(-2,2),
		Vector2i(2,-2),
		Vector2i(-2,-2),
		Vector2i(3,3),
		Vector2i(-3,3),
		Vector2i(3,-3),
		Vector2i(-3,-3)
	]
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile) or Global.is_chest_on_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords