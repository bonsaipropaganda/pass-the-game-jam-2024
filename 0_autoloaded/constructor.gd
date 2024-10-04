## globally accesible access to packed scenes
extends Node ## class_name Constructor (Autoloaded)

@export var TILE_HOVER_RECT:PackedScene = preload("res://scenes/ui/tile_hover_rect.tscn")
#---------------------------------------------------------------------------------------------------
@export var _TERRAIN:PackedScene = preload("res://terrain.tscn")
func instance_terrain(coord:Vector2i, type:E.TerrainType) -> Terrain:
	var new_terrain:Terrain = _TERRAIN.instantiate()
	new_terrain.construct(coord, type)
	return new_terrain
#---------------------------------------------------------------------------------------------------
@export var _ENEMY_GOBLIN:PackedScene = preload("res://entities/enemy_goblin.tscn")
func instance_enemy_goblin(coord:Vector2i) -> EnemyGoblin:
	var new_goblin:EnemyGoblin = _ENEMY_GOBLIN.instantiate()
	new_goblin.construct(coord)
	return new_goblin
#---------------------------------------------------------------------------------------------------
@export var _ENEMY_SLIME:PackedScene = preload("res://entities/enemy_slime.tscn")
func instance_enemy_slime(coord:Vector2i) -> EnemySlime:
	var new_slime:EnemySlime = _ENEMY_SLIME.instantiate()
	new_slime.construct(coord)
	return new_slime
#---------------------------------------------------------------------------------------------------
@export var _ENEMY_BAT:PackedScene = preload("res://entities/enemy_bat.tscn")
func instance_enemy_bat(coord:Vector2i) -> EnemyBat:
	var new_bat:EnemyBat = _ENEMY_BAT.instantiate()
	new_bat.construct(coord)
	return new_bat
#---------------------------------------------------------------------------------------------------
@export var _HERO_PALADIN:PackedScene = preload("res://entities/hero_paladin.tscn")
func instance_hero_paladin(coord:Vector2i) -> HeroPaladin:
	var new_paladin:HeroPaladin = _HERO_PALADIN.instantiate()
	new_paladin.construct(coord)
	return new_paladin
#---------------------------------------------------------------------------------------------------
@export var _HERO_ROGUE:PackedScene = preload("res://entities/hero_rogue.tscn")
func instance_hero_rogue(coord:Vector2i) -> HeroRogue:
	var new_rogue:HeroRogue = _HERO_ROGUE.instantiate()
	new_rogue.construct(coord)
	return new_rogue
#---------------------------------------------------------------------------------------------------
@export var _HERO_WIZARD:PackedScene = preload("res://entities/hero_wizard.tscn")
func instance_hero_wizard(coord:Vector2i) -> HeroWizard:
	var new_wizard:HeroWizard = _HERO_WIZARD.instantiate()
	new_wizard.construct(coord)
	return new_wizard
#---------------------------------------------------------------------------------------------------
@export var _ENTITY_EXIT_DOOR:PackedScene = preload("res://entities/exit_door.tscn")
func instance_exit_door(coord:Vector2i) -> Entity:
	var new_exit_door:ExitDoor = _ENTITY_EXIT_DOOR.instantiate()
	new_exit_door.construct(coord)
	return new_exit_door
#---------------------------------------------------------------------------------------------------
func swap_map(packed_map:PackedScene, enemy_spawn_weight:float) -> void:
	assert(Ref.world != null)
	
	for child in Ref.world.get_children(): child.queue_free()
	var new_map:Map = packed_map.instantiate()
	Ref.world.add_child(new_map)
	new_map.generate_map(enemy_spawn_weight)

@export var TEST_MAP:PackedScene = preload("res://maps/test_map.tscn")
