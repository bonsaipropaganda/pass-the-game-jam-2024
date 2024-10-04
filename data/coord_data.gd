class_name CoordData extends Resource

var coord:Vector2i
var terrain:Terrain
var entity:Entity
#---------------------------------------------------------------------------------------------------
func _init(coordinate:Vector2i) -> void:
	coord = coordinate
#---------------------------------------------------------------------------------------------------
func insert_entity(inserted_entity:Entity) -> void:
	assert(entity == null)
	entity = inserted_entity
#---------------------------------------------------------------------------------------------------
func remove_entity() -> void:
	assert(entity != null)
	entity = null
#---------------------------------------------------------------------------------------------------
func destroy_entity():
	assert(entity != null)
	entity.destroy()
	entity = null
#---------------------------------------------------------------------------------------------------
func has_entity() -> bool:
	if entity != null: return true
	else: return false
#---------------------------------------------------------------------------------------------------
