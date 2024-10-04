# The room is responsible for managing game elements that do not persist between rooms
# For example, spawning in elements and determining when the room is cleared
extends Node2D
class_name BaseRoom

var enemy_count := 0

@onready var tiles : TileMapLayer = $TileMap/Tiles
@onready var map_layers : Node2D = $TileMap

func _ready() -> void:
	if not Engine.is_editor_hint():
		SignalBus.enemy_died.connect(on_enemy_died)
		SignalBus.enemy_spawned.connect(enemy_spawned)

# Called by game manager to restrict camera movement
# func get_cam_limits() -> Vector2i:
# 	assert(room_size.x >= 20, "Don't go below the minimum room size! " + name)
# 	assert(room_size.y >= 11, "Don't go below the minimum room size! " + name)
# 	return room_size * C.TILE_SIZE

func on_enemy_died():
	enemy_count -= 1
	
	assert(enemy_count >= 0, "enemy count below zero somehow")
	
	if enemy_count == 0:
		on_room_complete()


func enemy_spawned():
	enemy_count += 1


func on_room_complete():
	SignalBus.room_complete.emit()
