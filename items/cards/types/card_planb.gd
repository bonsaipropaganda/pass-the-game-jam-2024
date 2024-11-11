class_name CardPlanB extends CardResource

func _init() -> void:
	card_name = "Plan B"
	description = """Allows you to run away to a nearby empty tile
[color=cyan]Move Shape:[/color]
	9x9 Grid.
[color=red]Discard on use.[/color]"""

func do_action(_pos :Vector2i):
	if CardActions.can_move_to_tile(_pos):
		await CardActions.move_to_tile(_pos)
		
		Global.game_manager.discard_card_resource(self)
		
	CardActions.end_turn()

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
	]
	for x in range (-4,4):
		for y in range(-4,4):
			if x == 0 and y == 0:
				continue
			offsets.append(Vector2i(x,y))
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if CardActions.can_move_to_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords
