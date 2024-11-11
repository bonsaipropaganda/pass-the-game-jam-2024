class_name CardPrincessBasic extends CardResource

func _init() -> void:
	card_name = "Princess"
	description = """[color=cyan]Move Shape:[/color] 
	2 Away Diagonals. 
[color=pink]Attack Shape:[/color] 
	2 Away Diagonals.
[color=red]On Discard:[/color]
	Lose."""

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i(2,2), ## DOWNRIGHT
		Vector2i(-2,2), ## DOWNLEFT
		Vector2i(-2,-2), ## UPLEFT
		Vector2i(2,-2) ## UPRIGHT
	]
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile) or Global.is_chest_on_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords

func on_discard() -> void:
	AudioManager.sfx_play(AudioManager.sfx_enum.KILL, 0.2, 3.0)
	# vv let's make a death sound as a start! vv
	SignalBus.game_over.emit()
	#assert(false, "You died! Currently there is no death functionality so I'm just gonna kill your game.")
