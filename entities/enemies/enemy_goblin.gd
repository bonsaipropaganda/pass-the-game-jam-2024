class_name EnemyGoblin extends BaseEnemy

func _ready():
	super()
	hp = 2
	
	type = E.EntityType.ENEMY
	specific_type = E.EntitySpecificType.GOBLIN

##every mob overrides this function
func get_coord() -> Vector2i: 
	var pos = Utils.global_pos_to_coord(global_position)
	var valid_coords:Array[Vector2i] = []
	
	var offsets:Array[Vector2i] = [
		Vector2i(1,0), ## RIGHT
		Vector2i(0,1), ## DOWN
		Vector2i(-1,0), ## LEFT
		Vector2i(0,-1), ## UP
	]
	
	for offset in offsets:
		var target_tile = pos + offset
		
		if Global.is_enemy_on_tile(target_tile) == true :
			continue
			
		if target_tile == Utils.global_pos_to_coord(get_tree().get_first_node_in_group("player").global_position):
			attack_player()
			return pos #current pos
			
		if Global.is_floor_tile(target_tile):
			valid_coords.append(target_tile)
			
	return valid_coords[randi() % valid_coords.size()]
