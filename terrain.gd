class_name Terrain extends Node2D

@onready var scaffold_gfx:Node2D = $Scaffold
@onready var floor_gfx:Node2D = $Floor
@onready var wall_gfx:Node2D = $Wall

@export var FLOOR_TEXTURES:Array[Texture]

@onready var scaffold_left: Sprite2D = $Scaffold/ScaffoldLeft
@export var SCAFFOLD_LEFT_FLAT_TEXTURES:Array[Texture]
@export var SCAFFOLD_LEFT_BEVELED_TEXTURES:Array[Texture]

@onready var scaffold_right: Sprite2D = $Scaffold/ScaffoldRight
@export var SCAFFOLD_RIGHT_FLAT_TEXTURES:Array[Texture]
@export var SCAFFOLD_RIGHT_BEVELED_TEXTURES:Array[Texture]

@onready var wall_downleft: Sprite2D = $Wall/WallDownleft
@export var WALL_DOWNLEFT_CONCAVE_CORNER_TEXTURES:Array[Texture]
@export var WALL_DOWNLEFT_CONVEX_CORNER_TEXTURES:Array[Texture]
@export var WALL_DOWNLEFT_HORIZONTAL_TEXTURES:Array[Texture]
@export var WALL_DOWNLEFT_VERTICAL_TEXTURES:Array[Texture]

@onready var wall_downright: Sprite2D = $Wall/WallDownright
@export var WALL_DOWNRIGHT_CONCAVE_CORNER_TEXTURES:Array[Texture]
@export var WALL_DOWNRIGHT_CONVEX_CORNER_TEXTURES:Array[Texture]
@export var WALL_DOWNRIGHT_HORIZONTAL_TEXTURES:Array[Texture]
@export var WALL_DOWNRIGHT_VERTICAL_TEXTURES:Array[Texture]

@onready var wall_upleft: Sprite2D = $Wall/WallUpleft
@export var WALL_UPLEFT_CONCAVE_CORNER_TEXTURES:Array[Texture]
@export var WALL_UPLEFT_CONVEX_CORNER_TEXTURES:Array[Texture]
@export var WALL_UPLEFT_HORIZONTAL_TEXTURES:Array[Texture]
@export var WALL_UPLEFT_VERTICAL_TEXTURES:Array[Texture]

@onready var wall_upright: Sprite2D = $Wall/WallUpright
@export var WALL_UPRIGHT_CONCAVE_CORNER_TEXTURES:Array[Texture]
@export var WALL_UPRIGHT_CONVEX_CORNER_TEXTURES:Array[Texture]
@export var WALL_UPRIGHT_HORIZONTAL_TEXTURES:Array[Texture]
@export var WALL_UPRIGHT_VERTICAL_TEXTURES:Array[Texture]

var coord:Vector2i
var type:E.TerrainType = E.TerrainType.NULL
#---------------------------------------------------------------------------------------------------
func construct(coordinate:Vector2i, terrain_type:E.TerrainType) -> void:
	coord = coordinate
	global_position = Utils.coord_to_global_pos(coordinate)
	type = terrain_type
#---------------------------------------------------------------------------------------------------
func _ready() -> void:
	SignalBus.terrain_changed.connect(_global_terrain_changed)
	update_terrain_type(type, true, false)
#---------------------------------------------------------------------------------------------------
func _global_terrain_changed() -> void:
	## WORK IN PROGRESS
	
	## the idea was to populate the exported arrays of sprites with textures and then update them if
	## or when any terrain was changed. Basically a dynamic autotile. Didn't have time to finish though... 
	#_update_scaffold_gfx()
	#_update_wall_gfx()
	pass
#---------------------------------------------------------------------------------------------------
func _update_wall_gfx() -> void:
	if type == E.TerrainType.PIT or type == E.TerrainType.FLOOR: return # GUARD CLAUSE
	## no time...
	pass
#---------------------------------------------------------------------------------------------------
func _update_scaffold_gfx() -> void:
	if type == E.TerrainType.PIT: return # GUARD CLAUSE
	
	var is_left_beveled:bool = false
	var downleft_coord:Vector2i = coord + Vector2i(-1,1)
	var left_coord:Vector2i = coord + Vector2i(-1,0)
	if Global.has_terrain(downleft_coord) and not Global.is_pit(downleft_coord): is_left_beveled = true
	elif Global.is_pit(left_coord): is_left_beveled = true
	
	if is_left_beveled: scaffold_left.texture = SCAFFOLD_LEFT_BEVELED_TEXTURES.pick_random()
	else: scaffold_left.texture = SCAFFOLD_LEFT_FLAT_TEXTURES.pick_random()
	
	var is_right_beveled:bool = false
	var downright_coord:Vector2i = coord + Vector2i(1,1)
	var right_coord:Vector2i = coord + Vector2i(1,0)
	if Global.has_terrain(downright_coord) and not Global.is_pit(downright_coord): is_right_beveled = true
	elif Global.is_pit(right_coord): is_right_beveled = true
	
	if is_right_beveled: scaffold_right.texture = SCAFFOLD_RIGHT_BEVELED_TEXTURES.pick_random()
	else: scaffold_right.texture = SCAFFOLD_RIGHT_FLAT_TEXTURES.pick_random()
#---------------------------------------------------------------------------------------------------
func update_terrain_type(new_type:E.TerrainType, force_update:bool = false, propagate_update:bool = true) -> void:
	if not force_update and new_type == type: return # GUARD CLAUSE
	
	match new_type:
		E.TerrainType.WALL: scaffold_gfx.show(); floor_gfx.show(); wall_gfx.show()
		E.TerrainType.FLOOR: scaffold_gfx.show(); floor_gfx.show(); wall_gfx.hide()
		E.TerrainType.PIT: scaffold_gfx.hide(); floor_gfx.hide(); wall_gfx.hide()
		E.TerrainType.BEDROCK: scaffold_gfx.show(); floor_gfx.show(); wall_gfx.show()
		_: breakpoint # ERROR (unhandled terrain type)
	
	type = new_type
	if propagate_update: SignalBus.terrain_changed.emit()
#---------------------------------------------------------------------------------------------------
