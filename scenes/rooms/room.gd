# The room is responsible for managing game elements that do not persist between rooms
# For example, spawning in elements and determining when the room is cleared
extends Node2D

@export var room_size = Vector2i(20, 11) # This is the minimum size, only go up from here

@export var min_enemy_count = 0
@export var max_enemy_count = 10
var enemy_count = randi_range(min_enemy_count, max_enemy_count) # This is then clamped to the number of spawners in the room

# This needs to be populated in the editor for every room
@export var enemy_options:Array[PackedScene] = [
	preload("res://scenes/enemy/base_enemy.tscn")
]


func _ready() -> void:
	if not Engine.is_editor_hint():
		spawn_enemies()
		Global.connect("enemy_died", on_enemy_died)


# Called by game manager to restrict camera movement
func get_cam_limits() -> Vector2i:
	assert(room_size.x >= 20, "Don't go below the minimum room size! " + name)
	assert(room_size.y >= 11, "Don't go below the minimum room size! " + name)
	return room_size * Global.TILE_SIZE


func spawn_enemies():
	var spawners = get_tree().get_nodes_in_group("enemy_spawner")
	spawners.shuffle()
	
	enemy_count = min(enemy_count, len(spawners))
	
	for i in min(enemy_count, len(spawners)):
		spawners[i].spawn(enemy_options.pick_random())


func on_enemy_died():
	enemy_count -= 1
	
	assert(enemy_count >= 0, "enemy count below zero somehow")
	
	if enemy_count == 0:
		on_room_complete()


func on_room_complete():
	Global.emit_signal("room_complete")
