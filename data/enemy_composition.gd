class_name EnemyComposition extends Resource

## this is 
@export_range(0, 100, 1, "or greater") var goblin_weight:float = 100
@export_range(0, 100, 1, "or greater") var slime_weight:float = 100
@export_range(0, 100, 1, "or greater") var bat_weight:float = 100

func instance_random(coord:Vector2i) -> Entity:
	var weight_floats:Array[float] = [ goblin_weight, slime_weight, bat_weight ]
	match Utils.weighted_randomness(weight_floats):
		0: return Constructor.instance_enemy_goblin(coord)
		1: return Constructor.instance_enemy_slime(coord)
		2: return Constructor.instance_enemy_bat(coord)
		_: breakpoint; return Constructor.instance_enemy_goblin(coord) # ERROR
