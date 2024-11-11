class_name CardKnightBasic extends CardResource

func _init() -> void:
	card_name = "Knight"
	description = """[color=green]Behavior:[/color]
	Agressive
[color=cyan]Move:[/color] 
	L-Shape
[color=pink]Attack:[/color] 
	L-Shape"""

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = Utils.get_target_rotations_with_mirror(Vector2i(2,1)) # gets all 8 offsets
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if CardActions.can_attack_tile(target_tile):
			valid_coords.append(target_tile)
	
	if valid_coords == []:
		for offset in offsets:
			var target_tile = player_pos + offset
			if CardActions.can_move_to_tile(target_tile):
				valid_coords.append(target_tile)
	
	return valid_coords

func do_action(tileCord:Vector2i) -> void:
	
	if CardActions.can_attack_tile(tileCord):
		
		if CardActions.can_kill_tile(tileCord,1):
			await CardActions.attack_tile(tileCord,1)
			await CardActions.move_to_tile(tileCord)
		
		else:
			await CardActions.attack_tile(tileCord,1)
			CardActions.end_turn()
	
	elif CardActions.can_move_to_tile(tileCord):
		await CardActions.move_to_tile(tileCord)
		CardActions.end_turn()
	
