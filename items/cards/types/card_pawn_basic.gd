class_name CardPawnBasic extends CardResource

func _init() -> void:
	card_name = "Pawn"
	description = "[color=gray]This card has no effect.[/color]"

# I am making this one do nothing since it is the only chess piece
# that has a different movement and attack pattern, and I don't have time to write that abstraction.
# The basic king card already lets you do everything a pawn can, so this does not really change anything.
func get_valid_coords(_player_pos:Vector2i) -> Array[Vector2i]:
	var ret:Array[Vector2i] = []
	return ret

# Note the card can still be used to discard, which may allow the player to
# save themselves discarding more valuable cards
