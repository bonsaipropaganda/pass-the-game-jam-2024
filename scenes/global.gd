# This script is an autoload
# It contains the global signals and utility functions
extends Node2D

const TILE_SIZE = 16

# This is emitted whenever enemies/things other than the player
# can move
signal game_tick


func global_to_tile_position(global_pos:Vector2) -> Vector2i:
	var int_pos = Vector2i(global_pos)
	return (int_pos / TILE_SIZE)


func is_floor_tile(tile_pos:Vector2i) -> bool:
	$TestRaycast.global_position = (tile_pos * TILE_SIZE) + (Vector2i(TILE_SIZE, TILE_SIZE) / 2)
	$TestRaycast.collision_mask = 1 # WallLayer
	$TestRaycast.force_raycast_update()
	return not $TestRaycast.is_colliding()

func is_enemy_on_tile(tile_pos:Vector2i) -> bool:
	$TestRaycast.global_position = (tile_pos * TILE_SIZE) + (Vector2i(TILE_SIZE, TILE_SIZE) / 2)
	$TestRaycast.collision_mask = 2 # ObjectLayer
	$TestRaycast.force_raycast_update()
	
	var col = $TestRaycast.get_collider()
	return (col != null) and col.is_in_group("enemy_area")


func attack_enemy_at_tile(tile_pos:Vector2i, damage:int):
	$TestRaycast.global_position = (tile_pos * TILE_SIZE) + (Vector2i(TILE_SIZE, TILE_SIZE) / 2)
	$TestRaycast.collision_mask = 2 # ObjectLayer
	$TestRaycast.force_raycast_update()
	var col = $TestRaycast.get_collider()
	if col.is_in_group("enemy_area"):
		await col.get_parent().take_damage(damage)


# Only rotates by multiples of 90 degrees
func rotate_vec2i(v: Vector2i, degrees_clockwise: int) -> Vector2i:
	assert(degrees_clockwise % 90 == 0, "rotate_vec2i() only rotates by multiples of 90 degrees")

	var num_rotations = (degrees_clockwise / 90) % 4

	match num_rotations:
		0:
			return v # No rotation
		1:
			return Vector2i(v.y, -v.x) # 90 degrees
		2:
			return Vector2i(-v.x, -v.y) # 180 degrees
		_:
			return Vector2i(-v.y, v.x) # 270 degrees


# To is between 0 and 1
func fade_black(to:float, duration:float):
	assert(to >= 0.0 and to <= 1.0)
	
	var tween = create_tween()
	tween.tween_property($GlobalUI/FadeBlackRect, "color:a", to, duration)
	await tween.finished
