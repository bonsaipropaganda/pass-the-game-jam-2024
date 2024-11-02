class_name CardPawnBasic extends CardResource

func _init() -> void:
	card_name = "Pawn"
	description = """
[color=green]Behavior:[/color]
	Agressive
	Promotable

[color=pink]Attack:[/color] 
	Top Right & Top Left"""

# I am making this one do nothing since it is the only chess piece
# that has a different movement and attack pattern, and I don't have time to write that abstraction.
# The basic king card already lets you do everything a pawn can, so this does not really change anything.


func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i(-1,-1), ## UPLEFT
		Vector2i(1,-1) ## UPRIGHT
	]
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if CardActions.can_kill_tile(target_tile,3):
			valid_coords.append(target_tile)
	
	return valid_coords



func do_action(tileCord:Vector2i) -> void:
	
	if CardActions.can_attack_tile(tileCord):
		await CardActions.attack_tile(tileCord,3)
		CardActions.promote()
	
	CardActions.end_turn()
