class_name EnemySlime extends BaseEnemy

func _ready():
	super()
	max_hp = 3
	hp = max_hp
	
	type = E.EntityType.ENEMY
	specific_type = E.EntitySpecificType.SLIME

func get_coord() -> Vector2i: 
	var pos = Utils.global_pos_to_coord(global_position)
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i(1,1), ## DOWNRIGHT
		Vector2i(-1,1), ## DOWNLEFT
		Vector2i(-1,-1), ## UPLEFT
		Vector2i(1,-1) ## UPRIGHT
	]
	
	for offset in offsets:
		var target_tile = pos + offset
		
		if Global.is_enemy_on_tile(target_tile) == true :
			continue
			
		if target_tile == Utils.global_pos_to_coord(get_tree().get_first_node_in_group("player").global_position):
			attack_player()
			return pos # returns just current pos, as it is needed by game_manager
			
		if Global.is_floor_tile(target_tile):
			valid_coords.append(target_tile)
			
	return valid_coords[randi() % valid_coords.size()]
