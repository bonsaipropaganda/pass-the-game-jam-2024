extends BaseRoomGenerator
class_name CastleBossGenerator

## determines when this generator will be used
func get_type() -> E.RoomType:
	return E.RoomType.BOSS


## determines the area that the generator belongs to
func get_area() -> String:
	return "castle"

## returns an array representing the room that will be generated
## the values in the array should match the values of a custom data layer on the used tileset called 'id'
## 0 is reserved for empty tiles. any values that don't match will also be empty
## the values should be in these ranges:
## 1 - 16 floor
## 17 - 32 walls
## add to this however you need
func generate_room(_dim: Vector2i, _danger_level: float) -> RoomData:
	var rooms: Array[Rect2i] = [
		Rect2i(10, 10, 9, 9),
		Rect2i(13, 19, 3, 6),
		Rect2i(12, 25, 5, 5),
	]
	var result := RoomData.new()
	result.dim_override = Vector2i(30, 40)
	result.tiles.resize(result.dim_override.x * result.dim_override.y)
	for i in result.tiles.size():
		var x = i % result.dim_override.x
		
		@warning_ignore("integer_division")
		var y = i / result.dim_override.x
		
		if rooms.any(func(a: Rect2i) -> bool:
				return a.has_point(Vector2i(x, y))):
			result.tiles[i] = ((i + y) % 2) + 1
		else:
			result.tiles[i] = 17
	
	result.scenes[Vector2i(rooms[2].position.x + int(rooms[2].size.x / 2.0), \
		rooms[2].position.y + int(rooms[2].size.y * 3.0 / 4))] = preload("res://entities/Player/player.tscn").instantiate()
	var exit: Exit = preload("res://entities/grid entities/room_exit.tscn").instantiate()
	exit.next_room_type = E.RoomType.SHOP
	result.scenes[Vector2i(rooms[0].position.x + int(rooms[0].size.x / 2.0), rooms[0].position.y - 1)] = exit
	result.scenes[Vector2i(rooms[0].position.x + int(rooms[0].size.x / 2.0) - 1, rooms[0].position.y - 1)] = preload("res://entities/grid entities/torch.tscn").instantiate()
	result.scenes[Vector2i(rooms[0].position.x + int(rooms[0].size.x / 2.0) + 1, rooms[0].position.y - 1)] = preload("res://entities/grid entities/torch.tscn").instantiate()
	return result


## returns the used TileSet. it should only have 1 source to make things easier to keep track of
func get_used_tileset() -> TileSet:
	return preload("res://rooms/castle_tile_set.tres")
