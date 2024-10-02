## TODO: implement shop
extends BaseRoomGenerator
class_name CastleShopGenerator

## determins when this generator will be used
func get_type() -> Exit.ExitType:
	return Exit.ExitType.SHOP


func get_area() -> String:
	return "castle"


## returns an array representing the room that will be generated
func generate_room(dim: Vector2i, _danger_level: float) -> PackedByteArray:
	var result := PackedByteArray()
	result.resize(dim.x * dim.y)
	for i in result.size():
		if i % dim.x != 0 and i / dim.x != 0 and i % dim.x != dim.x-1 and i / dim.x != dim.y-1:
			result[i] = 17
	return result


## returns the used TileSet. it should only have 1 source to make things easier to keep track of
func get_used_tileset() -> TileSet:
	return preload("res://scenes/rooms/castle_tile_set.tres")
