class_name CardBishopBasic extends CardResource

func _init() -> void:
	card_name = "Bishop"
	description = """[color=green]Behaviors:[/color]
	Neutral
[color=cyan]Move Shape:[/color] 
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
		if CardActions.can_move_to_tile(target_tile) or CardActions.can_loot_tile(target_tile) or CardActions.can_attack_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords

func do_action(tileCord:Vector2i) -> void:
	
	if CardActions.can_attack_tile(tileCord):
		await CardActions.attack_tile(tileCord,1)
	
	elif CardActions.can_move_to_tile(tileCord):
		await CardActions.move_to_tile(tileCord)
	
	elif CardActions.can_loot_tile(tileCord):
		await CardActions.loot_tile(tileCord)
	
	CardActions.end_turn()
