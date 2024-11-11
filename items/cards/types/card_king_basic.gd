class_name CardKingBasic extends CardResource

func _init() -> void:
	card_name = "King"
	description = """[color=green]Behaviors:[/color]
	Evasive
[color=cyan]Move:[/color] 
	3x3 Grid. 
[color=red]On Discard:[/color]
	Lose."""

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
		if CardActions.can_move_to_tile(target_tile) or CardActions.can_loot_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords

func on_discard() -> void:

	AudioManager.sfx_play(AudioManager.sfx_enum.KILL, 0.2, 3.0)
	# vv let's make a death sound as a start! vv
	SignalBus.game_over.emit()
	#assert(false, "You died! Currently there is no death functionality so I'm just gonna kill your game.")


func do_action(tileCord:Vector2i) -> void:
	
	print("b")
	
	if CardActions.can_attack_tile(tileCord):
		await CardActions.attack_tile(tileCord,1)
	
	elif CardActions.can_move_to_tile(tileCord):
		await CardActions.move_to_tile(tileCord)
	
	elif CardActions.can_loot_tile(tileCord):
		await CardActions.loot_tile(tileCord)
	
	CardActions.end_turn()
	
	
