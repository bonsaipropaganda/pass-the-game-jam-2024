class_name BaseEnemy extends Entity

@export var health_bar : HealthBar

var max_hp := 1
var hp := max_hp
# money dropped on death
var reward := 1

func _ready():
	SignalBus.enemy_spawned.emit(self)
	health_bar.update(hp, max_hp)


func take_damage(_hp_loss:int):
	hp -= 1
	health_bar.update(hp, max_hp)
	if hp <= 0:
		SignalBus.enemy_died.emit(self)
		AudioManager.sfx_play(AudioManager.sfx_enum.KILL, 0.2, 3.0)
		# trigger coin animation before death of enemy
		var coin = preload("res://items/coin_rotate.tscn").instantiate()
		add_child(coin)
		coin.play("coin_rotate")
		# show rotating coin for 0.3 sec, then let it fly to the upper corner towards the money counter
		await get_tree().create_timer(0.3).timeout
		var target_pos: Vector2 = get_viewport().get_camera_2d().position - (get_viewport_rect().size / 2)
		var coin_tween = create_tween()
		coin_tween.tween_property(coin, "global_position", target_pos, 0.6)
		await coin_tween.finished
		queue_free()

# selects to which file move or if attack
# every enemy overrides this function
func get_coord() -> Vector2i: 
	return Utils.global_pos_to_coord(global_position)
	
func move(to:Vector2i):
	$FootstepsPlayer.play()
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(to) * C.TILE_SIZE + (Vector2.ONE * C.TILE_SIZE / 2.0), 0.15)
	await tween.finished


func attack_player():
	get_tree().get_first_node_in_group("player").take_damage()
