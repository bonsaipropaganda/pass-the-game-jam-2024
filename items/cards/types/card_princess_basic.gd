class_name CardPrincessBasic extends CardResource

func _init() -> void:
	card_name = "Princess"
	description = """[color=cyan]Move Shape:[/color] 
	2 Away, Diagonals or
	X or Y 
[color=pink]Attack Shape:[/color] 
	2 Away, Diagonals.
[color=red]On Discard:[/color]
	Lose."""

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i.RIGHT, ## RIGHT
		
		Vector2i.DOWN, ## DOWN
		
		Vector2.LEFT, ## LEFT
		
		Vector2i.UP ## UP
		
	]
	
	var attack_offsets:Array[Vector2i] = [
		Vector2i(2,2), ## DOWNRIGHT
		
		Vector2i(-2,2), ## DOWNLEFT
		
		Vector2i(-2,-2), ## UPLEFT
		
		Vector2i(2,-2) ## UPRIGHT
	]
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if CardActions.can_move_to_tile(target_tile) or CardActions.can_loot_tile(target_tile):
			valid_coords.append(target_tile)
	
	for offset in attack_offsets:
		var target_tile = player_pos + offset
		if CardActions.can_attack_tile(target_tile) or CardActions.can_loot_tile(target_tile):
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

func on_discard() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.KILL, 0.2, 3.0)
	# vv let's make a death sound as a start! vv
	SignalBus.game_over.emit()
	#assert(false, "You died! Currently there is no death functionality so I'm just gonna kill your game.")
