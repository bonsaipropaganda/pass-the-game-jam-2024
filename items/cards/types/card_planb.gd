class_name CardPlanB extends CardResource

func _init() -> void:
	card_name = "Plan B"
	description = """Allows you to run away to a nearby empty tile
[color=cyan]Move Shape:[/color]
	4x4 Grid.
[color=red]Discard on use.[/color]"""

func do_action(pos :Vector2i):
	await SignalBus.game_tick
	Global.game_manager.players_cards.erase(Global.game_manager.selected_card)
	Global.game_manager.refresh_card_deck()

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
		if Global.is_floor_tile(target_tile) or Global.is_chest_on_tile(target_tile):
			valid_coords.append(target_tile)
		if Global.is_enemy_on_tile(target_tile):
			offsets.remove_at(offsets.find(offset))
	
	return valid_coords
