## Contains misc globally accessible data/functions
## ideally things should be split out into their relevant autoloads for better clarity
extends Node2D ## class_name Global (Autoloaded)
#---------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------
## boolean check on whether or not the coord is valid or out of bounds
func is_valid(coord:Vector2i) -> bool:
	if coord_data_or_null(coord) == null: return false
	else: return true
#---------------------------------------------------------------------------------------------------
## returns null if coord is out of bounds, otherwise returns the corresponding CoordData
func coord_data_or_null(coord:Vector2i) -> CoordData:
	return Ref.map.get_coord_data_or_null(coord)
#---------------------------------------------------------------------------------------------------
## Returns corresponding CoordData (Asserts coord is within bounds)
func coord_data(coord:Vector2i) -> CoordData:
	return Ref.map.get_coord_data(coord)
#---------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------
## Boolean check if coord has terrain
func has_terrain(coord:Vector2i) -> bool:
	if get_terrain_or_null(coord) == null: return false
	else: return true
#---------------------------------------------------------------------------------------------------
func get_terrain_or_null(coord:Vector2i) -> Terrain:
	var coordinate_data:CoordData = coord_data_or_null(coord)
	if coordinate_data == null: return null
	else:
		if coordinate_data.terrain: return coordinate_data.terrain
		else: return null
#---------------------------------------------------------------------------------------------------
func get_terrain(coord:Vector2i) -> Terrain:
	var terrain:Terrain = get_terrain_or_null(coord)
	assert(terrain != null)
	return terrain
#---------------------------------------------------------------------------------------------------
func is_terrain_type(type:E.TerrainType, coord:Vector2i) -> bool:
	var terrain:Terrain = get_terrain_or_null(coord)
	if terrain == null: return false
	else:
		if terrain.type == type: return true
		else: return false
#---------------------------------------------------------------------------------------------------
func is_floor(coord:Vector2) -> bool: return is_terrain_type(E.TerrainType.FLOOR, coord)
func is_wall(coord:Vector2i) -> bool: return is_terrain_type(E.TerrainType.WALL, coord)
func is_pit(coord:Vector2) -> bool: return is_terrain_type(E.TerrainType.PIT, coord)
func is_bedrock(coord:Vector2) -> bool: return is_terrain_type(E.TerrainType.BEDROCK, coord)
#---------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------
## Boolean check on whether the coord contains an entity or not
func contains_entity(coord:Vector2i) -> bool:
	if get_entity_or_null(coord) == null: return false
	else: return true
#---------------------------------------------------------------------------------------------------
## Returns null if the coord is out of bounds or if the coord does not contain an entity.
## Otherwise returns the Entity contained in the coord
func get_entity_or_null(coord:Vector2i) -> Entity:
	var coordinate_data:CoordData = coord_data_or_null(coord)
	if coordinate_data == null: return null
	else:
		if coordinate_data.entity == null: return null
		else: return coordinate_data.entity
#---------------------------------------------------------------------------------------------------
## Returns the Entity contained in the coord (Asserts the coord is valid and that it contains an entity)
func get_entity(coord:Vector2i) -> Entity:
	var entity:Entity = get_entity_or_null(coord)
	assert(entity != null)
	return entity
#---------------------------------------------------------------------------------------------------
func contains_entity_type(type:E.EntityType, coord:Vector2i) -> bool:
	var entity:Entity = get_entity_or_null(coord)
	if entity == null: return false
	else:
		if entity.type == type: return true
		else: return false
#---------------------------------------------------------------------------------------------------
func contains_hero(coord:Vector2i) -> bool: return contains_entity_type(E.EntityType.HERO, coord)
func contains_enemy(coord:Vector2i) -> bool: return contains_entity_type(E.EntityType.ENEMY, coord)
func contains_neutral(coord:Vector2i) -> bool: return contains_entity_type(E.EntityType.NEUTRAL, coord)
#---------------------------------------------------------------------------------------------------
func contains_entity_specific_type(specific_type:E.EntitySpecificType, coord:Vector2i) -> bool:
	var entity:Entity = get_entity_or_null(coord)
	if entity == null: return false
	else:
		if entity.specific_type == specific_type: return true
		else: return false
#---------------------------------------------------------------------------------------------------
func contains_paladin(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.PALADIN, coord)
func contains_rogue(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.ROGUE, coord)
func contains_wizard(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.WIZARD, coord)
func contains_goblin(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.GOBLIN, coord)
func contains_slime(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.SLIME, coord)
func contains_bat(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.BAT, coord)
func contains_exit_door(coord:Vector2i) -> bool: return contains_entity_specific_type(E.EntitySpecificType.EXIT_DOOR, coord)
#---------------------------------------------------------------------------------------------------








func is_floor_tile(tile_pos:Vector2i) -> bool:
	$TestRaycast.global_position = (tile_pos * C.TILE_SIZE) + (Vector2i(C.TILE_SIZE, C.TILE_SIZE) / 2)
	$TestRaycast.collision_mask = 1 # WallLayer
	$TestRaycast.force_raycast_update()
	return not $TestRaycast.is_colliding()

func is_enemy_on_tile(tile_pos:Vector2i) -> bool:
	$TestRaycast.global_position = (tile_pos * C.TILE_SIZE) + (Vector2i(C.TILE_SIZE, C.TILE_SIZE) / 2)
	$TestRaycast.collision_mask = 2 # ObjectLayer
	$TestRaycast.force_raycast_update()
	
	var col = $TestRaycast.get_collider()
	return (col != null) and col.is_in_group("enemy_area")


func attack_enemy_at_tile(tile_pos:Vector2i, damage:int):
	$TestRaycast.global_position = (tile_pos * C.TILE_SIZE) + (Vector2i(C.TILE_SIZE, C.TILE_SIZE) / 2)
	$TestRaycast.collision_mask = 2 # ObjectLayer
	$TestRaycast.force_raycast_update()
	var col = $TestRaycast.get_collider()
	if col.is_in_group("enemy_area"):
		await col.get_parent().take_damage(damage)

# To is between 0 and 1
func fade_black(to:float, duration:float):
	assert(to >= 0.0 and to <= 1.0)
	
	var tween = create_tween()
	tween.tween_property($GlobalUI/FadeBlackRect, "color:a", to, duration)
	await tween.finished

func rand_point_in_rect(rect: Rect2i) -> Vector2i:
	return Vector2i(randi_range(rect.position.x, rect.position.x + rect.size.x - 1), randi_range(rect.position.y, rect.position.y + rect.size.y - 1))
