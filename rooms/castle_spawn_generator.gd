class_name CastleSpawnGenerator extends BaseRoomGenerator

func get_type() -> E.RoomType:
	return E.RoomType.SPAWN

func get_area() -> String:
	return "castle"

func generate_room(_dim: Vector2i, _danger_level: float) -> RoomData:
	var result := RoomData.new()
	var room_size = Vector2i(21, 21)
	var center = room_size / 2
	
	# fill in the room with walls first
	result.tiles.resize(room_size.x * room_size.y)
	result.tiles.fill(17)
	
	# fill in the floors in the center area of the room
	for x in range(center.x-2, center.x+3):
		for y in range(center.y-5, center.y+3):
			result.tiles[y*room_size.x + x] = 1
	
	# place the exit at the top-center, and player at the bottom-ish center
	var exit = preload("res://entities/grid entities/room_exit.tscn").instantiate() as Exit
	exit.next_room_type = E.RoomType.MONEY_REWARD
	result.scenes = {
		Vector2i(center.x, center.y): preload("res://entities/Player/player.tscn").instantiate(),
		Vector2i(center.x, center.y-6): exit
	}
	
	# this room has a fixed size (21,21)
	result.dim_override = room_size
	return result


func get_used_tileset() -> TileSet:
	return preload("res://rooms/castle_tile_set.tres")
