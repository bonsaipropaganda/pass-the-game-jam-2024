## Globally accesible constants
extends Node ## class_name C (Autoloaded)

const TILE_SIZE:int = 16

@export var FLOOR_HOVER_COLOR:= Color(0, 0.74, 0.257)
@export var ENEMY_HOVER_COLOR:= Color(0.654, 0.208, 0.098)
#---------------------------------------------------------------------------------------------------
@export_group(&"Entity")
## how long it visually takes a piece to move
@export var ENTITY_MOVE_TWEEN_SECONDS:float = 0.3

## the curve that determines the visual hop of an entity when moving
@export var ENTITY_HOP_CURVE:Curve

## the amount an entity will visuall hop when moving
@export var ENTITY_HOP_HEIGHT:float = 12.0
#---------------------------------------------------------------------------------------------------
