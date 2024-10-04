## Base for any moveable object / character
class_name Entity extends Node2D

var global_coord:Vector2i
var type:E.EntityType
var specific_type:E.EntitySpecificType

var move_tween:Tween
var tween_from_pos:Vector2
var tween_to_pos:Vector2
var inverted_hop:bool = false
#---------------------------------------------------------------------------------------------------
func construct(coord:Vector2i) -> void:
	global_coord = coord
	global_position = Utils.coord_to_global_pos(coord)
	Global.coord_data(coord).insert_entity(self)
#---------------------------------------------------------------------------------------------------
func move_to_free(target_global_coord:Vector2i) -> void:
	assert(target_global_coord != global_coord, "tried to move to current tile")
	assert(Global.coord_data(target_global_coord).entity == null)
	
	## handles visual update of movement of entity
	if move_tween: move_tween.kill()
	inverted_hop = false
	tween_from_pos = global_position
	tween_to_pos = Utils.coord_to_global_pos(target_global_coord)
	move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	move_tween.tween_method(move_tween_func, 0.0, 1.0, C.ENTITY_MOVE_TWEEN_SECONDS)
	
	## Updates CoordData
	Ref.map.move_entity(global_coord, target_global_coord)
#---------------------------------------------------------------------------------------------------
func swap_with_occupied(target_global_coord:Vector2i) -> void:
	assert(target_global_coord != global_coord, "tried to swap with current tile")
	assert(Global.coord_data(target_global_coord).entity != null)
	
	## handles visual update of movement of this entity and the opposing entity
	var swap_entity:Entity = Global.coord_data(target_global_coord).entity
	if move_tween: move_tween.kill()
	inverted_hop = false
	tween_from_pos = global_position
	tween_to_pos = Utils.coord_to_global_pos(target_global_coord)
	move_tween = create_tween()
	move_tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	move_tween.tween_method(move_tween_func, 0.0, 1.0, C.ENTITY_MOVE_TWEEN_SECONDS)
	
	if swap_entity.move_tween: swap_entity.move_tween.kill()
	swap_entity.inverted_hop = true
	swap_entity.tween_from_pos = swap_entity.global_position
	swap_entity.tween_to_pos = Utils.coord_to_global_pos(global_coord)
	swap_entity.move_tween = create_tween()
	swap_entity.move_tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	swap_entity.move_tween.tween_method(swap_entity.move_tween_func, 0.0, 1.0, C.ENTITY_MOVE_TWEEN_SECONDS)
	
	## Updates CoordData
	Ref.map.swap_entities(global_coord, target_global_coord)
#---------------------------------------------------------------------------------------------------
func move_tween_func(weight:float) -> void:
	var updated_pos:= tween_from_pos.lerp(tween_to_pos, weight)
	if inverted_hop: updated_pos.y += C.ENTITY_HOP_CURVE.sample_baked(weight) * C.ENTITY_HOP_HEIGHT
	else: updated_pos.y += C.ENTITY_HOP_CURVE.sample_baked(weight) * -C.ENTITY_HOP_HEIGHT
	global_position = updated_pos
#---------------------------------------------------------------------------------------------------
func destroy() -> void: queue_free()
#---------------------------------------------------------------------------------------------------
