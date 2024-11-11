class_name CardJester extends CardResource

var rng = RandomNumberGenerator.new()

func _init() -> void:
	card_name = "Jester"
	description = """[color=cyan]Move Shape:[/color] 
	Random (max 8). 
[color=pink]Attack Shape:[/color] 
	Random (max 8)."""

func get_valid_coords(player_pos:Vector2i) -> Array[Vector2i]:
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = []
	
	var spots = rng.randi_range(0,32)
	for spot in spots:
		var loc = Vector2i(rng.randi_range(-8,8),rng.randi_range(-8,8))
		if loc == Vector2i.ZERO:
			continue
		offsets.append(loc)
	
	for offset in offsets:
		var target_tile = player_pos + offset
		if Global.is_floor_tile(target_tile) or Global.is_chest_on_tile(target_tile):
			valid_coords.append(target_tile)
	
	return valid_coords
