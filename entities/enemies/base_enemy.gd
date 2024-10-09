class_name BaseEnemy extends Node2D

var hp

var type:E.EntityType
var specific_type:E.EntitySpecificType

func _ready():
	SignalBus.enemy_spawned.emit(self)


func take_damage(_hp_loss:int):
	hp -= 1
	if hp < 0:
		SignalBus.enemy_died.emit(self)
		queue_free()

func get_coord() -> Vector2i: 
	return Utils.global_pos_to_coord(global_position)
	
func move(to:Vector2i):
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(to) * C.TILE_SIZE + (Vector2.ONE * C.TILE_SIZE / 2.0), 0.15)
	await tween.finished


func attack_player():
	get_tree().get_first_node_in_group("player").take_damage()
