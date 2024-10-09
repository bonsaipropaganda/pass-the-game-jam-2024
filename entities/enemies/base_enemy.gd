## This serves as an example of an enemy, although it does not actually attack you
## Other enemies can inherit this or whatever works best
class_name BaseEnemy extends Node2D

var hp = 2

func _ready():
	SignalBus.enemy_spawned.emit(self)


func take_damage(_hp_loss:int):
	hp -= 1
	if hp > 0:
		$AnimationPlayer.play("take_damage")
		await $AnimationPlayer.animation_finished
	else:
		$AnimationPlayer.play("die")
		await $AnimationPlayer.animation_finished
		SignalBus.enemy_died.emit(self)
		queue_free()

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
			return pos##current pos
			
		if Global.is_floor_tile(target_tile):
			valid_coords.append(target_tile)
			
	return valid_coords[randi() % valid_coords.size()]
	
func move(to:Vector2i):
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(to) * C.TILE_SIZE + (Vector2.ONE * C.TILE_SIZE / 2.0), 0.15)
	await tween.finished


func attack_player():
	get_tree().get_first_node_in_group("player").take_damage()
