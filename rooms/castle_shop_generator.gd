## TODO: implement shop
class_name CastleShopGenerator extends BaseRoomGenerator

## determins when this generator will be used
func get_type() -> E.RoomType:
	return E.RoomType.SHOP


func get_area() -> String:
	return "castle"


## returns an array representing the room that will be generated
func generate_room(dim: Vector2i, _danger_level: float) -> RoomData:
	var result := RoomData.new()
	result.tiles.resize(dim.x * dim.y)
	
	var room := Rect2i(Vector2i.ONE * 11, Vector2i.ONE * 11)
	
	for i in result.tiles.size():
		var x := i % dim.x
		var y := i / dim.x
		if not room.has_point(Vector2i(x, y)):
			result.tiles[i] = 17
		else:
			result.tiles[i] = ((i + y) % 2) + 1

	var center_x = room.position.x + int(room.size.x / 2.0)
	var center_y = room.position.y + int(room.size.y / 2.0)
	result.scenes[Vector2i(center_x, room.position.y + int(room.size.y * 3.0 / 4))] = preload("res://entities/Player/player.tscn").instantiate()
	var exit: Exit = preload("res://entities/grid entities/room_exit.tscn").instantiate()
	result.scenes[Vector2i(center_x, room.position.y - 1)] = exit
	result.scenes[Vector2i(center_x - 1, room.position.y - 1)] = preload("res://entities/grid entities/torch.tscn").instantiate()
	result.scenes[Vector2i(center_x + 1, room.position.y - 1)] = preload("res://entities/grid entities/torch.tscn").instantiate()
	
	result.scenes[Vector2i(center_x - 2, center_y)] = preload("res://entities/grid entities/shop_item.tscn").instantiate()
	result.scenes[Vector2i(center_x, center_y)] = preload("res://entities/grid entities/shop_item.tscn").instantiate()
	result.scenes[Vector2i(center_x + 2, center_y)] = preload("res://entities/grid entities/shop_item.tscn").instantiate()
	exit.next_room_type = E.RoomType.MONEY_REWARD

	return result


## returns the used TileSet. it should only have 1 source to make things easier to keep track of
func get_used_tileset() -> TileSet:
	return preload("res://rooms/castle_tile_set.tres")
