extends Resource
class_name BaseRoomGenerator

## determines when this generator will be used
func get_type() -> Exit.ExitType:
	return Exit.ExitType.MONEY_REWARD


## determines the area that the generator belongs to
func get_area() -> String:
	return ""

## returns an array representing the room that will be generated
## the values in the array should match the values of a custom data layer on the used tileset called 'id'
## 0 is reserved for empty tiles. any values that don't match will also be empty
## the values should be in these ranges:
## 1 - 16 floor
## 17 - 32 walls
## 33 exit (will have wall 17 under)
## 34 chest (will have floor 1 under)
## 35 torch (will have wall 17 under)
## add to this however you need
func generate_room(_dim: Vector2i, _danger_level: float) -> PackedByteArray:
	return []


## returns the used TileSet. it should only have 1 source to make things easier to keep track of
func get_used_tileset() -> TileSet:
	return null
