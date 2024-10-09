class_name Map extends Node2D

@onready var _init_terrain_map:TileMapLayer = $InitTerrainMap
@onready var _init_entities_map:TileMapLayer = $InitEntitiesMap
@onready var _terrain_root:Node2D = $TerrainRoot
@onready var _entities_root:Node2D = $EntitiesRoot

@export var _min_enemy_count:int
@export var _max_enemy_count:int


@export_group(&"Enemy composition weight")
## the relative likelihoods of the various enemies to be spawned
@export var _enemy_composition:EnemyComposition


var _grid_rows:int
var _grid_cols:int
## I'm using a 1D array instead of a 2D array so there is intellisense
## Besides, nothing outside of this script should access _grid directly, instead they should call coord_data()
var _grid:Array[CoordData] = []

func _ready() -> void: Ref.map = self
#---------------------------------------------------------------------------------------------------
func move_entity(from_coord:Vector2i, to_coord:Vector2i) -> void:
	assert(get_coord_data(from_coord).entity != null)
	assert(get_coord_data(to_coord).entity == null)
	print("hello")
	var entity_to_move:Entity = get_coord_data(from_coord).entity
	get_coord_data(from_coord).remove_entity()
	get_coord_data(to_coord).insert_entity(entity_to_move)
	
	entity_to_move.global_coord = to_coord
#---------------------------------------------------------------------------------------------------
func swap_entities(coord_a:Vector2i, coord_b:Vector2i) -> void:
	assert(get_coord_data(coord_a).entity != null)
	assert(get_coord_data(coord_b).entity != null)
	
	var entity_a:Entity = get_coord_data(coord_a).entity
	var entity_b:Entity = get_coord_data(coord_b).entity
	get_coord_data(coord_a).remove_entity()
	get_coord_data(coord_b).remove_entity()
	get_coord_data(coord_a).insert_entity(entity_b)
	get_coord_data(coord_b).insert_entity(entity_a)
	
	entity_a.global_coord = coord_b
	entity_b.global_coord = coord_a
#---------------------------------------------------------------------------------------------------
func get_coord_data_or_null(coord:Vector2i) -> CoordData:
	if coord.x < 0 or coord.x >= _grid_cols: return null
	elif coord.y < 0 or coord.y >= _grid_rows: return null
	else: return _grid[ coord.y * _grid_cols + coord.x ]
#---------------------------------------------------------------------------------------------------
func get_coord_data(coord:Vector2i) -> CoordData:
	var data:CoordData = get_coord_data_or_null(coord)
	assert(data != null, "coord is out of bounds")
	return data
#---------------------------------------------------------------------------------------------------
## You can try to break this function up if you care, but the logic is fairly self contained as is
## I've done my best to give a high level overview of what each section of the function does
## There are probably simpler ways of doing some of this stuff but oh well
func generate_map(enemy_spawn_weight:float) -> void:
	## STEP:
	## Determine the upleft and downright corner coords for the bounding box containing all cells
	 
	var local_used_coords:Array[Vector2i] = _init_terrain_map.get_used_cells()
	var upleft_bounding_coord:Vector2i = local_used_coords[0] # initiliazed to point since it is knwon to be in bounding box
	var downright_bounding_coord:Vector2i = local_used_coords[0] # initiliazed to point since it is knwon to be in bounding box
	for coord in local_used_coords:
		# checks to see if upleft or downright corners of the bounding box need to be stretched to accomodate the coord
		upleft_bounding_coord.x = mini(upleft_bounding_coord.x, coord.x)
		downright_bounding_coord.x = maxi(downright_bounding_coord.x, coord.x)
		upleft_bounding_coord.y = mini(upleft_bounding_coord.y, coord.y)
		downright_bounding_coord.y = maxi(downright_bounding_coord.y, coord.y)
	
	## STEP:
	## Detmine grid dimensions and correction offset
	
	_grid_cols = downright_bounding_coord.x - upleft_bounding_coord.x + 1
	_grid_rows = downright_bounding_coord.y - upleft_bounding_coord.y + 1
	var correction_offset:Vector2i = -upleft_bounding_coord
	
	## STEP:
	## Generate _grid with 'empty' CoordData (it has its coords but no terrain or entity data yet)
	
	for row in _grid_rows:
		var grid_row:Array[CoordData] = []
		
		for col in _grid_cols:
			grid_row.append(CoordData.new(Vector2i(col, row)))
		
		_grid.append_array(grid_row)
	
	## STEP:
	## Instantiate and assign Terrain to relevant CoordData
	
	for coord in local_used_coords:
		var corrected_coord:Vector2i = coord + correction_offset
		var new_terrain:Terrain
		
		match _init_terrain_map.get_cell_atlas_coords(coord):
			Vector2i(0,0): ## FLOOR
				new_terrain = Constructor.instance_terrain(corrected_coord, E.TerrainType.FLOOR)
			
			Vector2i(1,0): ## WALL
				new_terrain = Constructor.instance_terrain(corrected_coord, E.TerrainType.WALL)
			
			Vector2i(2,0): ## PIT
				new_terrain = Constructor.instance_terrain(corrected_coord, E.TerrainType.PIT)
			
			Vector2i(3,0): ## BEDROCK
				new_terrain = Constructor.instance_terrain(corrected_coord, E.TerrainType.BEDROCK)
		
		get_coord_data(corrected_coord).terrain = new_terrain
		_terrain_root.add_child(new_terrain)
	
	SignalBus.terrain_changed.emit()
	
	## STEP:
	## ????
	
	var possible_enemy_spawn_coords:Array[Vector2i] = []
	var possible_hero_spawn_coords:Array[Vector2i] = []
	
	for entity_coord in _init_entities_map.get_used_cells():
		var corrected_coord:Vector2i = entity_coord + correction_offset
		var coord_data:CoordData = get_coord_data_or_null(corrected_coord)
		assert(coord_data != null, "An entity spawn was placed outside of the bounds described by InitTerrainMap")
		assert(coord_data.terrain.type != E.TerrainType.WALL and coord_data.terrain.type != E.TerrainType.BEDROCK, "An entity spawn was placed inside a wall or bedrock")
		
		match _init_entities_map.get_cell_atlas_coords(entity_coord):
			Vector2i(0,0): ## ENEMY SPAWN
				possible_enemy_spawn_coords.append(corrected_coord)
			
			Vector2i(1,0): ## EXIT_DOOR
				var new_exit_door:ExitDoor = Constructor.instance_exit_door(corrected_coord)
				_entities_root.add_child(new_exit_door)
			
			Vector2i(2,0): ## HERO_SPAWN
				possible_hero_spawn_coords.append(corrected_coord)
	
	## STEP:
	## instantiate heroes
	
	assert(possible_hero_spawn_coords.size() >= 3, \
	"not enough hero spawn locations. Make sure there are at least 3 spawn locations in InitEntitiesMap")
	
	var paladin_coord:Vector2i = Utils.pop_random(possible_hero_spawn_coords)
	var paladin:HeroPaladin = Constructor.instance_hero_paladin(paladin_coord)
	_entities_root.add_child(paladin)
	
	var rogue_coord:Vector2i = Utils.pop_random(possible_hero_spawn_coords)
	var rogue:HeroRogue = Constructor.instance_hero_rogue(rogue_coord)
	_entities_root.add_child(rogue)
	
	var wizard_coord:Vector2i = Utils.pop_random(possible_hero_spawn_coords)
	var wizard:HeroWizard = Constructor.instance_hero_wizard(wizard_coord)
	_entities_root.add_child(wizard)
	
	## STEP:
	## Instantiate enemies
	
	assert(enemy_spawn_weight >= 0 and enemy_spawn_weight <= 1, \
	"enemy spawn weight must be between 0 and 1")
	assert(_max_enemy_count >= _min_enemy_count, \
	"min_enemy_count is greater than max_enemy_count")
	assert(possible_enemy_spawn_coords.size() >= _max_enemy_count, \
	"not enough enemy spawn locations. Reduce max enemy count or add more spawn positions to InitEntitiesMap")
	assert(_enemy_composition != null, \
	"enemy composition is not entered")
	
	var enemy_count:int = int(lerpf(_min_enemy_count, _max_enemy_count, enemy_spawn_weight))
	for i in enemy_count:
		var spawn_coord:Vector2i = Utils.pop_random(possible_enemy_spawn_coords)
		var enemy:Entity = _enemy_composition.instance_random(spawn_coord)
		_entities_root.add_child(enemy)
	
	## STEP:
	## remove init_terrain_map and init_entities_map, as they're no longer needed
	
	_init_terrain_map.queue_free()
	_init_entities_map.queue_free()
#---------------------------------------------------------------------------------------------------
