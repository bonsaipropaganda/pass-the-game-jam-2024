class_name Utils extends Node
#---------------------------------------------------------------------------------------------------
## converts global position to the overlapping tile coordinate
static func global_pos_to_coord(global_position:Vector2) -> Vector2i:
	@warning_ignore("narrowing_conversion")
	return Vector2i(global_position.x / C.TILE_SIZE, global_position.y / C.TILE_SIZE)
#---------------------------------------------------------------------------------------------------
static func coord_to_global_pos(global_coord:Vector2i) -> Vector2:
	return Vector2(global_coord.x * C.TILE_SIZE, global_coord.y * C.TILE_SIZE)
#---------------------------------------------------------------------------------------------------
## rotates vector2i only in 90 degree intervals
static func rotate_vec2i(vec2i:Vector2i, degrees_clockwise:int) -> Vector2i:
	assert(degrees_clockwise % 90 == 0, "rotate_vec2i() only rotates by multiples of 90 degrees")
	
	@warning_ignore("integer_division")
	var num_rotations = (degrees_clockwise / 90) % 4
	match num_rotations:
		0: return vec2i # No rotation
		1, -3: return Vector2i(-vec2i.y, vec2i.x) # 90° clockwise (270° counterclockwise)
		2, -2: return Vector2i(-vec2i.x, -vec2i.y) # 180° clockwise (180° counterclockwise)
		3, -1: return Vector2i(vec2i.y, -vec2i.x) # 270° clockwise (90° counterclockwise)
		_: breakpoint; return Vector2i.ZERO # ERROR
#---------------------------------------------------------------------------------------------------
## returns an array of 4 coords based on vec2i rotated in 90° segments in a circle
static func get_target_rotations(vec2i:Vector2i) -> Array[Vector2i]:
	var rotations:Array[Vector2i]
	rotations.append(vec2i) # No rotation
	rotations.append(Vector2i(-vec2i.y, vec2i.x)) # 90° clockwise (270° counterclockwise)
	rotations.append(Vector2i(-vec2i.x, -vec2i.y)) # 180° clockwise (180° counterclockwise)
	rotations.append(Vector2i(vec2i.y, -vec2i.x)) # 270° clockwise (90° counterclockwise)
	return rotations
#---------------------------------------------------------------------------------------------------
## returns an array of 8 coords based on vec2i, including four 90° rotations in a circle
## for both mirrored and non-mirrored versions
static func get_target_rotations_with_mirror(vec2i:Vector2i) -> Array[Vector2i]:
	assert(abs(vec2i.x) != abs(vec2i.y), "A 45° rotation cannot be mirrored")
	assert(vec2i.x != 0 and vec2i.y != 0, "A vertical / horizontal rotation cannot be mirrored")
	
	var rotations:Array[Vector2i] = get_target_rotations(vec2i)
	rotations.append_array(get_target_rotations(Vector2i(-vec2i.x, vec2i.y)))
	return rotations
#---------------------------------------------------------------------------------------------------
## returns the index of the float weight that was picked
static func weighted_randomness(array_of_float_weights:Array[float]) -> int:
	for weight_float in array_of_float_weights: assert(weight_float >= 0)
	
	var weight_sum := 0.0

	for weight in array_of_float_weights: 
		weight_sum += weight

	if weight_sum == 0: return randi_range(0, array_of_float_weights.size() - 1)
	
	var float_to_check:float = randf_range(0, weight_sum)
	for pick in array_of_float_weights.size():
		if float_to_check < array_of_float_weights[pick]: return pick
		else: float_to_check -= array_of_float_weights[pick]
	
	breakpoint; return 0 # ERROR
#---------------------------------------------------------------------------------------------------
## pops a random element of an array, removing it from the array and returning the value
static func pop_random(array:Array):
	return array.pop_at(randi_range(0, array.size() - 1))
#---------------------------------------------------------------------------------------------------
static func string_map_to_vec2i_array(string_map:String) -> Array[Vector2i]:
	var center_offset:Vector2i = Vector2i(-1,-1)
	var vec2i_array:Array[Vector2i] = []
	
	var current_coord:= Vector2i(0,0)
	for character in string_map:
		match character:
			"_":
				current_coord.x += 1
			
			"O":
				vec2i_array.append(current_coord)
				current_coord.x += 1
			
			"\n":
				current_coord.y += 1
				current_coord.x = 0
			
			"X":
				assert(center_offset == Vector2i(-1,-1), "More than 1 center assigned. The map string should only have one 'X'")
				center_offset = current_coord
			
			" ": pass
			_: breakpoint # ERROR
	
	for i in vec2i_array.size(): vec2i_array[i] -= center_offset
	return vec2i_array
#---------------------------------------------------------------------------------------------------
