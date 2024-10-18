extends BaseRoomGenerator
class_name CastleMoneyGenerator

## determines when this generator will be used
func get_type() -> E.RoomType:
	return E.RoomType.MONEY_REWARD


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
func generate_room(dim: Vector2i, danger_level: float) -> RoomData:
	var rooms: Array[Rect2i]
	for i in 5:
		rooms.append(Rect2i(randi_range(2, dim.x - 15), randi_range(2, dim.y - 15), randi_range(5, 9), randi_range(5, 9)))
	
	var start_room: Rect2i = rooms.pick_random()
	var exit_room: Rect2i = rooms.pick_random()
	var treasure_room: Rect2i = rooms.pick_random()
	var fight_rooms: Array[Rect2i] = []
	for i in danger_level:
		fight_rooms.append(rooms.pick_random())
	
	var result := RoomData.new()
	result.tiles.resize(dim.x * dim.y)
	
	var floor_tiles: Array[int] = []
	
	for i in result.tiles.size():
		var x = i % dim.x

		@warning_ignore("integer_division")
		var y = i / dim.x
		
		if rooms.any(func(a: Rect2i) -> bool:
				return a.has_point(Vector2i(x, y))):
			result.tiles[i] = ((i + y) % 2) + 1
			floor_tiles.append(i)
		else:
			result.tiles[i] = 17
	
	# detect separated sections of floor
	var floor_sections: Array[Array] = []
	var scanned := {}
	while not floor_tiles.is_empty():
		var search_stack: Array[int] = [floor_tiles.pop_back()]
		scanned[search_stack[0]] = true
		var floor_section: Array[int] = [search_stack[0]]
		floor_tiles.erase(search_stack[0])
		
		while not search_stack.is_empty():
			var pos: int = search_stack.pop_back()
			var adj: Array[int] = [
				pos - 1,
				pos + 1,
				pos - dim.x,
				pos + dim.x,
			]
			for i in adj:
				if i < 0 or i >= result.tiles.size(): continue
				if not scanned.has(i) and (result.tiles[i] == 1 or result.tiles[i] == 2):
					search_stack.append(i)
					scanned[i] = true
					floor_tiles.erase(i)
					floor_section.append(i)
		
		floor_sections.append(floor_section)

	# FIXME make this correctly connect all rooms. it will ocationally miss a room 
	rooms.clear()
	for i in floor_sections.size():
		var start = floor_sections[i].pick_random()
		var end = floor_sections[(i + 1) % floor_sections.size()].pick_random()
		start = Vector2i(start % dim.x, start / dim.x)
		end = Vector2i(end % dim.x, end / dim.x)
		var top = Vector2i(min(start.x, end.x), min(start.y, end.y))
		var bottom = Vector2i(max(start.x, end.x), max(start.y, end.y))
		
		rooms.append(Rect2i(top, Vector2i(3, bottom.y - top.y + 4)))
		rooms.append(Rect2i(Vector2i(top.x, bottom.y), Vector2i(bottom.x - top.x + 4, 3)))
	
	for i in result.tiles.size():
		var x = i % dim.x

		@warning_ignore("integer_division")
		var y = i / dim.x
		
		if rooms.any(func(a: Rect2i) -> bool:
				return a.has_point(Vector2i(x, y))):
			result.tiles[i] = ((i + y) % 2) + 1
			floor_tiles.append(i)
	
	result.scenes[Global.rand_point_in_rect(start_room)] = preload("res://entities/Player/player.tscn").instantiate()
	result.scenes[Global.rand_point_in_rect(treasure_room)] = preload("res://entities/grid entities/chest.tscn").instantiate()
	
	var enemy_count = 1
	for i in fight_rooms:
		for j in enemy_count:
			result.scenes[Global.rand_point_in_rect(i)] = preload("res://entities/enemies/enemy_goblin.tscn").instantiate()
			result.scenes[Global.rand_point_in_rect(i)] = preload("res://entities/enemies/enemy_slime.tscn").instantiate()
			result.scenes[Global.rand_point_in_rect(i)] = preload("res://entities/enemies/enemy_bat.tscn").instantiate()
	
	var door_pos: Vector2i = Global.rand_point_in_rect(exit_room)
	while result.tiles[door_pos.x + door_pos.y * dim.x] == 1 or result.tiles[door_pos.x + door_pos.y * dim.x] == 2:
		door_pos.y -= 1
	
	var exit: Exit = preload("res://entities/grid entities/room_exit.tscn").instantiate()
	match randi_range(0, 2):
		0:
			exit.next_room_type = E.RoomType.MONEY_REWARD
		1:
			exit.next_room_type = E.RoomType.SHOP
		2:
			exit.next_room_type = E.RoomType.BOSS
	result.scenes[door_pos] = exit
	return result


## returns the used TileSet. it should only have 1 source to make things easier to keep track of
func get_used_tileset() -> TileSet:
	return preload("res://rooms/castle_tile_set.tres")
